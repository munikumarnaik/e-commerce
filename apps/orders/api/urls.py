from django.urls import path

from . import views

app_name = 'orders'

urlpatterns = [
    path('orders/', views.OrderListView.as_view(), name='order-list'),
    path('orders/create/', views.OrderCreateView.as_view(), name='order-create'),
    path('orders/<str:order_number>/', views.OrderDetailView.as_view(), name='order-detail'),
    path('orders/<str:order_number>/cancel/', views.OrderCancelView.as_view(), name='order-cancel'),
    path('orders/<str:order_number>/reorder/', views.OrderReorderView.as_view(), name='order-reorder'),
    path('orders/<str:order_number>/track/', views.OrderTrackView.as_view(), name='order-track'),
]
