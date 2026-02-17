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

    # Admin endpoints
    path('admin/orders/', views.AdminOrderListView.as_view(), name='admin-order-list'),
    path('admin/orders/<uuid:order_id>/', views.AdminOrderDetailView.as_view(), name='admin-order-detail'),
    path('admin/orders/<uuid:order_id>/status/', views.AdminOrderStatusUpdateView.as_view(), name='admin-order-status'),
    path('admin/dashboard/stats/', views.AdminDashboardStatsView.as_view(), name='admin-dashboard-stats'),

    # Vendor endpoints
    path('vendor/orders/', views.VendorOrderListView.as_view(), name='vendor-order-list'),
    path('vendor/dashboard/', views.VendorDashboardView.as_view(), name='vendor-dashboard'),
]
