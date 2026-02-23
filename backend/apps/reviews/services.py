import logging

from django.db import transaction
from django.db.models import Avg, Count, Q
from rest_framework.exceptions import ValidationError

from apps.orders.models import OrderItem
from apps.reviews.models import HelpfulVote, Review, ReviewImage

logger = logging.getLogger(__name__)


def _is_verified_purchase(user, product):
    """Check if the user has a delivered order containing this product."""
    return OrderItem.objects.filter(
        order__user=user,
        order__status='DELIVERED',
        product=product,
    ).exists()


def _update_product_rating(product):
    """Re-compute denormalized average_rating and total_reviews on Product."""
    stats = Review.objects.filter(
        product=product, is_approved=True,
    ).aggregate(
        avg=Avg('rating'),
        count=Count('id'),
    )
    product.average_rating = round(stats['avg'] or 0, 2)
    product.total_reviews = stats['count'] or 0
    product.save(update_fields=['average_rating', 'total_reviews', 'updated_at'])


@transaction.atomic
def create_review(user, product, rating, title='', comment='', image_urls=None):
    """Create a new review for a product."""
    if Review.objects.filter(product=product, user=user).exists():
        raise ValidationError({'review': 'You have already reviewed this product.'})

    verified = _is_verified_purchase(user, product)

    review = Review.objects.create(
        product=product,
        user=user,
        rating=rating,
        title=title,
        comment=comment,
        is_verified_purchase=verified,
    )

    if image_urls:
        for url in image_urls[:5]:  # max 5 images
            ReviewImage.objects.create(review=review, image=url)

    _update_product_rating(product)
    return review


@transaction.atomic
def update_review(user, review_id, rating=None, title=None, comment=None):
    """Update an existing review."""
    try:
        review = Review.objects.get(id=review_id, user=user)
    except Review.DoesNotExist:
        raise ValidationError({'review': 'Review not found.'})

    if rating is not None:
        review.rating = rating
    if title is not None:
        review.title = title
    if comment is not None:
        review.comment = comment
    review.save()

    _update_product_rating(review.product)
    return review


@transaction.atomic
def delete_review(user, review_id):
    """Delete a review."""
    try:
        review = Review.objects.get(id=review_id, user=user)
    except Review.DoesNotExist:
        raise ValidationError({'review': 'Review not found.'})

    product = review.product
    review.delete()
    _update_product_rating(product)


def get_product_reviews(product_slug, filters=None):
    """Get reviews for a product with optional filtering."""
    qs = Review.objects.filter(
        product__slug=product_slug,
        is_approved=True,
    ).select_related('user').prefetch_related('images', 'response__user')

    if filters:
        rating = filters.get('rating')
        if rating:
            qs = qs.filter(rating=int(rating))

        verified_only = filters.get('verified_only')
        if verified_only in ('true', '1', True):
            qs = qs.filter(is_verified_purchase=True)

        with_images = filters.get('with_images')
        if with_images in ('true', '1', True):
            qs = qs.filter(images__isnull=False).distinct()

        sort = filters.get('sort', '-created_at')
        allowed_sorts = {
            'newest': '-created_at',
            'oldest': 'created_at',
            'highest': '-rating',
            'lowest': 'rating',
            'helpful': '-helpful_count',
        }
        qs = qs.order_by(allowed_sorts.get(sort, '-created_at'))

    return qs


def get_reviews_summary(product):
    """Get star distribution and stats for a product."""
    qs = Review.objects.filter(product=product, is_approved=True)

    distribution = dict(
        qs.values('rating').annotate(count=Count('id')).values_list('rating', 'count')
    )

    return {
        'average_rating': float(product.average_rating),
        'total_reviews': product.total_reviews,
        '5_star': distribution.get(5, 0),
        '4_star': distribution.get(4, 0),
        '3_star': distribution.get(3, 0),
        '2_star': distribution.get(2, 0),
        '1_star': distribution.get(1, 0),
    }


@transaction.atomic
def toggle_helpful(user, review_id):
    """Toggle a helpful vote on a review. Returns True if added, False if removed."""
    try:
        review = Review.objects.get(id=review_id, is_approved=True)
    except Review.DoesNotExist:
        raise ValidationError({'review': 'Review not found.'})

    if review.user_id == user.id:
        raise ValidationError({'review': 'You cannot vote on your own review.'})

    vote, created = HelpfulVote.objects.get_or_create(review=review, user=user)

    if created:
        review.helpful_count += 1
        review.save(update_fields=['helpful_count'])
        return True
    else:
        vote.delete()
        review.helpful_count = max(0, review.helpful_count - 1)
        review.save(update_fields=['helpful_count'])
        return False
