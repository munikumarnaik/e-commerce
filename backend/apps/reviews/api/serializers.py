from rest_framework import serializers

from apps.reviews.models import HelpfulVote, Review, ReviewImage, ReviewResponse


class ReviewImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReviewImage
        fields = ['id', 'image', 'created_at']
        read_only_fields = ['id', 'created_at']


class ReviewResponseSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.full_name', read_only=True)

    class Meta:
        model = ReviewResponse
        fields = ['id', 'user_name', 'comment', 'created_at']
        read_only_fields = ['id', 'created_at']


class ReviewSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.full_name', read_only=True)
    user_avatar = serializers.CharField(source='user.profile_image', read_only=True)
    images = ReviewImageSerializer(many=True, read_only=True)
    response = ReviewResponseSerializer(read_only=True)
    has_voted_helpful = serializers.SerializerMethodField()

    class Meta:
        model = Review
        fields = [
            'id', 'user_name', 'user_avatar',
            'rating', 'title', 'comment',
            'is_verified_purchase', 'helpful_count',
            'images', 'response', 'has_voted_helpful',
            'created_at', 'updated_at',
        ]

    def get_has_voted_helpful(self, obj):
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return False
        return HelpfulVote.objects.filter(review=obj, user=request.user).exists()


class CreateReviewSerializer(serializers.Serializer):
    product_slug = serializers.SlugField()
    rating = serializers.IntegerField(min_value=1, max_value=5)
    title = serializers.CharField(max_length=200, required=False, default='')
    comment = serializers.CharField()
    image_urls = serializers.ListField(
        child=serializers.URLField(),
        required=False,
        max_length=5,
        default=list,
    )


class UpdateReviewSerializer(serializers.Serializer):
    rating = serializers.IntegerField(min_value=1, max_value=5, required=False)
    title = serializers.CharField(max_length=200, required=False)
    comment = serializers.CharField(required=False)
