from django.urls import path

from . import views

app_name = 'payments'

urlpatterns = [
    path('payments/initiate/', views.PaymentInitiateView.as_view(), name='payment-initiate'),
    path('payments/verify/', views.PaymentVerifyView.as_view(), name='payment-verify'),
    path('payments/webhook/', views.PaymentWebhookView.as_view(), name='payment-webhook'),
    path('payments/refund/', views.PaymentRefundView.as_view(), name='payment-refund'),
    path('payments/<str:order_number>/', views.PaymentStatusView.as_view(), name='payment-status'),
]
