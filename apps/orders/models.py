import uuid
from datetime import datetime

from django.conf import settings
from django.db import models
from django.utils import timezone


class Coupon(models.Model):
    class DiscountType(models.TextChoices):
        PERCENTAGE = 'PERCENTAGE', 'Percentage'
        FIXED = 'FIXED', 'Fixed'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    code = models.CharField(max_length=50, unique=True)

    discount_type = models.CharField(max_length=20, choices=DiscountType.choices)
    discount_value = models.DecimalField(max_digits=10, decimal_places=2)
    max_discount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    # Conditions
    min_order_value = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    max_usage = models.PositiveIntegerField(null=True, blank=True)
    usage_per_user = models.PositiveIntegerField(default=1)

    # Validity
    valid_from = models.DateTimeField()
    valid_until = models.DateTimeField()

    # Stats
    usage_count = models.PositiveIntegerField(default=0)

    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'coupons'
        indexes = [
            models.Index(fields=['code', 'is_active'], name='idx_coupons_code_active'),
            models.Index(fields=['valid_from', 'valid_until'], name='idx_coupons_validity'),
        ]

    def __str__(self):
        return f'{self.code} ({self.discount_type}: {self.discount_value})'

    @property
    def is_valid(self):
        now = timezone.now()
        if not self.is_active:
            return False
        if now < self.valid_from or now > self.valid_until:
            return False
        if self.max_usage and self.usage_count >= self.max_usage:
            return False
        return True

    def calculate_discount(self, subtotal):
        """Calculate the discount amount for a given subtotal."""
        from decimal import Decimal

        if subtotal < self.min_order_value:
            return Decimal('0.00')

        if self.discount_type == self.DiscountType.PERCENTAGE:
            discount = (subtotal * self.discount_value / Decimal('100')).quantize(Decimal('0.01'))
            if self.max_discount:
                discount = min(discount, self.max_discount)
        else:
            discount = min(self.discount_value, subtotal)

        return discount


class Order(models.Model):
    class Status(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        CONFIRMED = 'CONFIRMED', 'Confirmed'
        PROCESSING = 'PROCESSING', 'Processing'
        SHIPPED = 'SHIPPED', 'Shipped'
        OUT_FOR_DELIVERY = 'OUT_FOR_DELIVERY', 'Out for Delivery'
        DELIVERED = 'DELIVERED', 'Delivered'
        CANCELLED = 'CANCELLED', 'Cancelled'
        REFUNDED = 'REFUNDED', 'Refunded'

    class PaymentStatus(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        PAID = 'PAID', 'Paid'
        FAILED = 'FAILED', 'Failed'
        REFUNDED = 'REFUNDED', 'Refunded'

    # Allowed status transitions
    VALID_TRANSITIONS = {
        'PENDING': ['CONFIRMED', 'CANCELLED'],
        'CONFIRMED': ['PROCESSING', 'CANCELLED'],
        'PROCESSING': ['SHIPPED', 'CANCELLED'],
        'SHIPPED': ['OUT_FOR_DELIVERY'],
        'OUT_FOR_DELIVERY': ['DELIVERED'],
        'DELIVERED': [],
        'CANCELLED': ['REFUNDED'],
        'REFUNDED': [],
    }

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    order_number = models.CharField(max_length=20, unique=True)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT,
        related_name='orders',
    )

    # Address snapshots (JSON — address may be deleted later)
    shipping_address = models.JSONField()
    billing_address = models.JSONField(null=True, blank=True)

    # Status
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    payment_status = models.CharField(max_length=20, choices=PaymentStatus.choices, default=PaymentStatus.PENDING)

    # Pricing
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)
    tax = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    shipping_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    discount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    total = models.DecimalField(max_digits=10, decimal_places=2)

    # Payment
    payment_method = models.CharField(max_length=50, default='cod')
    payment_id = models.CharField(max_length=255, blank=True, default='')
    transaction_id = models.CharField(max_length=255, blank=True, default='')

    # Delivery
    tracking_number = models.CharField(max_length=100, blank=True, default='')
    estimated_delivery = models.DateTimeField(null=True, blank=True)
    delivered_at = models.DateTimeField(null=True, blank=True)

    # Notes
    customer_note = models.TextField(blank=True, default='')
    admin_note = models.TextField(blank=True, default='')

    # Coupon
    coupon = models.ForeignKey(Coupon, on_delete=models.SET_NULL, null=True, blank=True, related_name='orders')

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'orders'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['order_number'], name='idx_orders_number'),
            models.Index(fields=['user', '-created_at'], name='idx_orders_user_created'),
            models.Index(fields=['status', 'payment_status'], name='idx_orders_status_payment'),
            models.Index(fields=['-created_at'], name='idx_orders_created_desc'),
        ]

    def __str__(self):
        return self.order_number

    @staticmethod
    def generate_order_number():
        """Generate a unique order number: ORD-YYYY-XXXXXX."""
        year = datetime.now().year
        import random
        while True:
            number = f'ORD-{year}-{random.randint(100000, 999999)}'
            if not Order.objects.filter(order_number=number).exists():
                return number

    def can_transition_to(self, new_status):
        """Check if a status transition is valid."""
        return new_status in self.VALID_TRANSITIONS.get(self.status, [])

    @property
    def is_cancellable(self):
        return self.status in ('PENDING', 'CONFIRMED', 'PROCESSING')


class OrderItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey('products.Product', on_delete=models.PROTECT, related_name='order_items')
    variant = models.ForeignKey(
        'products.ProductVariant', on_delete=models.PROTECT,
        related_name='order_items', null=True, blank=True,
    )

    # Snapshot data (product may change later)
    product_name = models.CharField(max_length=255)
    product_image = models.URLField()
    sku = models.CharField(max_length=100)
    variant_size = models.CharField(max_length=20, blank=True, default='')
    variant_color = models.CharField(max_length=50, blank=True, default='')

    # Pricing
    quantity = models.PositiveIntegerField()
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    discount = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    vendor = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.PROTECT, related_name='vendor_order_items',
    )

    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'order_items'
        indexes = [
            models.Index(fields=['order'], name='idx_order_items_order'),
            models.Index(fields=['product'], name='idx_order_items_product'),
            models.Index(fields=['vendor'], name='idx_order_items_vendor'),
        ]

    def __str__(self):
        return f'{self.product_name} x{self.quantity}'


class OrderStatusHistory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='status_history')

    status = models.CharField(max_length=20, choices=Order.Status.choices)
    notes = models.TextField(blank=True, default='')
    changed_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL,
        null=True, blank=True, related_name='order_status_changes',
    )

    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'order_status_history'
        ordering = ['created_at']
        indexes = [
            models.Index(fields=['order', '-created_at'], name='idx_order_status_order_created'),
        ]

    def __str__(self):
        return f'{self.order.order_number} → {self.status}'
