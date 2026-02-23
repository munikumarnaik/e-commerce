from rest_framework import status
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.products.models import Product
from apps.reviews import services
from .serializers import (
    CreateReviewSerializer,
    ReviewSerializer,
    UpdateReviewSerializer,
)


class ProductReviewListView(APIView):
    """GET /reviews/{product_slug}/ — List reviews for a product."""
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request, product_slug, *args, **kwargs):
        reviews = services.get_product_reviews(product_slug, filters=request.query_params)
        serializer = ReviewSerializer(reviews, many=True, context={'request': request})
        return Response({
            'success': True,
            'data': {
                'count': reviews.count(),
                'results': serializer.data,
            },
        })


class ProductReviewSummaryView(APIView):
    """GET /reviews/{product_slug}/summary/ — Rating distribution."""
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request, product_slug, *args, **kwargs):
        try:
            product = Product.objects.get(slug=product_slug, is_active=True)
        except Product.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Product not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        summary = services.get_reviews_summary(product)
        return Response({'success': True, 'data': summary})


class CreateReviewView(APIView):
    """POST /reviews/ — Create a new review."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = CreateReviewSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        try:
            product = Product.objects.get(slug=data['product_slug'], is_active=True)
        except Product.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Product not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        review = services.create_review(
            user=request.user,
            product=product,
            rating=data['rating'],
            title=data.get('title', ''),
            comment=data['comment'],
            image_urls=data.get('image_urls'),
        )

        return Response(
            {
                'success': True,
                'data': ReviewSerializer(review, context={'request': request}).data,
                'message': 'Review submitted successfully.',
            },
            status=status.HTTP_201_CREATED,
        )


class UpdateReviewView(APIView):
    """PATCH /reviews/{review_id}/ — Update own review."""
    permission_classes = [IsAuthenticated]

    def patch(self, request, review_id, *args, **kwargs):
        serializer = UpdateReviewSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        review = services.update_review(
            user=request.user,
            review_id=review_id,
            rating=data.get('rating'),
            title=data.get('title'),
            comment=data.get('comment'),
        )

        return Response({
            'success': True,
            'data': ReviewSerializer(review, context={'request': request}).data,
            'message': 'Review updated.',
        })


class DeleteReviewView(APIView):
    """DELETE /reviews/{review_id}/ — Delete own review."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, review_id, *args, **kwargs):
        services.delete_review(user=request.user, review_id=review_id)
        return Response({'success': True, 'message': 'Review deleted.'})


class ToggleHelpfulView(APIView):
    """POST /reviews/{review_id}/helpful/ — Toggle helpful vote."""
    permission_classes = [IsAuthenticated]

    def post(self, request, review_id, *args, **kwargs):
        added = services.toggle_helpful(user=request.user, review_id=review_id)
        return Response({
            'success': True,
            'data': {'is_helpful': added},
            'message': 'Marked as helpful.' if added else 'Removed helpful vote.',
        })
