import uuid

from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils import timezone


class Review(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.ForeignKey(
        'products.Product', on_delete=models.CASCADE, related_name='reviews',
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reviews',
    )

    rating = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
    )
    title = models.CharField(max_length=200, blank=True, default='')
    comment = models.TextField()

    is_verified_purchase = models.BooleanField(default=False)
    is_approved = models.BooleanField(default=True)

    helpful_count = models.PositiveIntegerField(default=0)

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'reviews'
        ordering = ['-created_at']
        unique_together = [('product', 'user')]
        indexes = [
            models.Index(fields=['product', '-created_at'], name='idx_reviews_product_created'),
            models.Index(fields=['product', '-rating'], name='idx_reviews_product_rating'),
            models.Index(fields=['user'], name='idx_reviews_user'),
        ]

    def __str__(self):
        return f'{self.user} → {self.product.name} ({self.rating}★)'


class ReviewImage(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    review = models.ForeignKey(Review, on_delete=models.CASCADE, related_name='images')
    image = models.URLField()
    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'review_images'
        ordering = ['created_at']

    def __str__(self):
        return f'Image for review {self.review_id}'


class ReviewResponse(models.Model):
    """Vendor / admin reply to a review."""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    review = models.OneToOneField(Review, on_delete=models.CASCADE, related_name='response')
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='review_responses',
    )
    comment = models.TextField()
    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'review_responses'

    def __str__(self):
        return f'Response to review {self.review_id}'


class HelpfulVote(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    review = models.ForeignKey(Review, on_delete=models.CASCADE, related_name='helpful_votes')
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='helpful_votes',
    )
    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'helpful_votes'
        unique_together = [('review', 'user')]

    def __str__(self):
        return f'{self.user} → helpful vote on {self.review_id}'
