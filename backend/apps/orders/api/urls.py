from django.urls import path

from . import views

app_name = 'orders'

urlpatterns = [
    # Customer endpoints
    path('orders/', views.OrderListView.as_view(), name='order-list'),
    path('orders/create/', views.OrderCreateView.as_view(), name='order-create'),
    path('orders/<str:order_number>/', views.OrderDetailView.as_view(), name='order-detail'),
    path('orders/<str:order_number>/cancel/', views.OrderCancelView.as_view(), name='order-cancel'),
    path('orders/<str:order_number>/reorder/', views.OrderReorderView.as_view(), name='order-reorder'),
    path('orders/<str:order_number>/track/', views.OrderTrackView.as_view(), name='order-track'),

    # Public coupon endpoint
    path('coupons/available/', views.AvailableCouponsView.as_view(), name='available-coupons'),

    # Admin order endpoints
    path('admin/orders/', views.AdminOrderListView.as_view(), name='admin-order-list'),
    path('admin/orders/<uuid:order_id>/', views.AdminOrderDetailView.as_view(), name='admin-order-detail'),
    path('admin/orders/<uuid:order_id>/status/', views.AdminOrderStatusUpdateView.as_view(), name='admin-order-status'),
    path('admin/dashboard/stats/', views.AdminDashboardStatsView.as_view(), name='admin-dashboard-stats'),

    # Admin coupon endpoints
    path('admin/coupons/', views.AdminCouponListView.as_view(), name='admin-coupon-list'),
    path('admin/coupons/create/', views.AdminCouponCreateView.as_view(), name='admin-coupon-create'),
    path('admin/coupons/<uuid:coupon_id>/update/', views.AdminCouponUpdateView.as_view(), name='admin-coupon-update'),
    path('admin/coupons/<uuid:coupon_id>/delete/', views.AdminCouponDeleteView.as_view(), name='admin-coupon-delete'),
    path('admin/coupons/<uuid:coupon_id>/toggle/', views.AdminCouponToggleView.as_view(), name='admin-coupon-toggle'),

    # Vendor endpoints
    path('vendor/orders/', views.VendorOrderListView.as_view(), name='vendor-order-list'),
    path('vendor/dashboard/', views.VendorDashboardView.as_view(), name='vendor-dashboard'),
]
