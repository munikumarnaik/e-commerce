from django.urls import path

from . import views

urlpatterns = [
    # Create a review
    path('reviews/', views.CreateReviewView.as_view(), name='review-create'),

    # List reviews for a product
    path('reviews/<slug:product_slug>/', views.ProductReviewListView.as_view(), name='review-list'),

    # Review summary (star distribution)
    path('reviews/<slug:product_slug>/summary/', views.ProductReviewSummaryView.as_view(), name='review-summary'),

    # Update / delete own review
    path('reviews/<uuid:review_id>/update/', views.UpdateReviewView.as_view(), name='review-update'),
    path('reviews/<uuid:review_id>/delete/', views.DeleteReviewView.as_view(), name='review-delete'),

    # Toggle helpful vote
    path('reviews/<uuid:review_id>/helpful/', views.ToggleHelpfulView.as_view(), name='review-helpful'),
]
