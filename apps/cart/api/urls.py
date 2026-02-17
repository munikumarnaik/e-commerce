from django.urls import path

from . import views

app_name = 'cart'

urlpatterns = [
    # Cart
    path('cart/', views.CartView.as_view(), name='cart-detail'),
    path('cart/add/', views.CartAddView.as_view(), name='cart-add'),
    path('cart/items/<uuid:item_id>/', views.CartItemUpdateView.as_view(), name='cart-item-update'),
    path('cart/items/<uuid:item_id>/delete/', views.CartItemDeleteView.as_view(), name='cart-item-delete'),
    path('cart/clear/', views.CartClearView.as_view(), name='cart-clear'),
    path('cart/apply-coupon/', views.CartApplyCouponView.as_view(), name='cart-apply-coupon'),
    path('cart/remove-coupon/', views.CartRemoveCouponView.as_view(), name='cart-remove-coupon'),

    # Wishlist
    path('wishlist/', views.WishlistView.as_view(), name='wishlist-detail'),
    path('wishlist/add/', views.WishlistAddView.as_view(), name='wishlist-add'),
    path('wishlist/remove/<uuid:product_id>/', views.WishlistRemoveView.as_view(), name='wishlist-remove'),
    path('wishlist/move-to-cart/<uuid:product_id>/', views.WishlistMoveToCartView.as_view(), name='wishlist-move-to-cart'),
    path('wishlist/clear/', views.WishlistClearView.as_view(), name='wishlist-clear'),
]
