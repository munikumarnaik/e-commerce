from django.contrib import admin

from .models import HelpfulVote, Review, ReviewImage, ReviewResponse


class ReviewImageInline(admin.TabularInline):
    model = ReviewImage
    extra = 0


class ReviewResponseInline(admin.StackedInline):
    model = ReviewResponse
    extra = 0
    max_num = 1


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ['user', 'product', 'rating', 'is_verified_purchase', 'is_approved', 'helpful_count', 'created_at']
    list_filter = ['rating', 'is_verified_purchase', 'is_approved']
    search_fields = ['user__email', 'product__name', 'comment']
    readonly_fields = ['id', 'helpful_count', 'created_at', 'updated_at']
    inlines = [ReviewImageInline, ReviewResponseInline]


@admin.register(HelpfulVote)
class HelpfulVoteAdmin(admin.ModelAdmin):
    list_display = ['user', 'review', 'created_at']
    readonly_fields = ['id', 'created_at']
