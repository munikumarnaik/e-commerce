import uuid

from django.conf import settings
from django.db import models
from django.utils import timezone


class Payment(models.Model):
    class Gateway(models.TextChoices):
        RAZORPAY = 'RAZORPAY', 'Razorpay'
        COD = 'COD', 'Cash on Delivery'
        STRIPE = 'STRIPE', 'Stripe'

    class Status(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        PROCESSING = 'PROCESSING', 'Processing'
        COMPLETED = 'COMPLETED', 'Completed'
        FAILED = 'FAILED', 'Failed'
        REFUNDED = 'REFUNDED', 'Refunded'
        PARTIALLY_REFUNDED = 'PARTIALLY_REFUNDED', 'Partially Refunded'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    order = models.ForeignKey(
        'orders.Order',
        on_delete=models.PROTECT,
        related_name='payments',
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name='payments',
    )

    gateway = models.CharField(max_length=20, choices=Gateway.choices)
    status = models.CharField(max_length=30, choices=Status.choices, default=Status.PENDING)

    # Gateway-specific IDs
    gateway_order_id = models.CharField(max_length=255, blank=True, default='')
    gateway_payment_id = models.CharField(max_length=255, blank=True, default='')
    gateway_signature = models.CharField(max_length=512, blank=True, default='')

    # Amounts
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=10, default='INR')
    amount_refunded = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    # Refund tracking
    refund_id = models.CharField(max_length=255, blank=True, default='')

    # Error tracking
    failure_code = models.CharField(max_length=100, blank=True, default='')
    failure_description = models.TextField(blank=True, default='')

    # Webhook data (raw payload for audit)
    webhook_data = models.JSONField(null=True, blank=True)

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'payments'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['order'], name='idx_payments_order'),
            models.Index(fields=['user', '-created_at'], name='idx_payments_user_created'),
            models.Index(fields=['gateway_order_id'], name='idx_payments_gateway_order'),
            models.Index(fields=['gateway_payment_id'], name='idx_payments_gateway_payment'),
            models.Index(fields=['status'], name='idx_payments_status'),
        ]

    def __str__(self):
        return f'{self.order.order_number} — {self.gateway} ({self.status})'

    @property
    def is_successful(self):
        return self.status == self.Status.COMPLETED

    @property
    def is_refundable(self):
        return self.status == self.Status.COMPLETED and self.gateway == self.Gateway.RAZORPAY

    @property
    def refundable_amount(self):
        from decimal import Decimal
        return max(self.amount - self.amount_refunded, Decimal('0.00'))
