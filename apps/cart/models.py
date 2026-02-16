import uuid
from datetime import timedelta

from django.conf import settings
from django.db import models
from django.utils import timezone


class Cart(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='cart',
    )
    session_key = models.CharField(max_length=255, unique=True, blank=True, null=True)

    # Cached totals
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    tax = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    discount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    expires_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'carts'
        indexes = [
            models.Index(fields=['user'], name='idx_carts_user'),
        ]

    def __str__(self):
        return f'Cart({self.user.email})'

    def save(self, *args, **kwargs):
        if not self.expires_at:
            self.expires_at = timezone.now() + timedelta(days=30)
        super().save(*args, **kwargs)

    @property
    def is_expired(self):
        return self.expires_at and timezone.now() > self.expires_at

    @property
    def items_count(self):
        return self.items.count()

    def recalculate(self):
        """Recalculate cart totals from items."""
        from decimal import Decimal

        items = self.items.select_related('product', 'variant')
        subtotal = Decimal('0.00')
        for item in items:
            subtotal += item.total_price

        tax_rate = Decimal('0.18')  # 18% GST
        tax = (subtotal * tax_rate).quantize(Decimal('0.01'))

        self.subtotal = subtotal
        self.tax = tax
        self.discount = Decimal('0.00')
        self.total = subtotal + tax - self.discount
        self.expires_at = timezone.now() + timedelta(days=30)
        self.save(update_fields=['subtotal', 'tax', 'discount', 'total', 'expires_at', 'updated_at'])

    def clear_items(self):
        """Remove all items from the cart."""
        self.items.all().delete()
        self.recalculate()


class CartItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(
        'products.Product',
        on_delete=models.CASCADE,
        related_name='cart_items',
    )
    variant = models.ForeignKey(
        'products.ProductVariant',
        on_delete=models.CASCADE,
        related_name='cart_items',
        blank=True,
        null=True,
    )

    quantity = models.PositiveIntegerField(default=1)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'cart_items'
        unique_together = [('cart', 'product', 'variant')]
        indexes = [
            models.Index(fields=['cart'], name='idx_cart_items_cart'),
            models.Index(fields=['product'], name='idx_cart_items_product'),
        ]

    def __str__(self):
        return f'{self.product.name} x{self.quantity}'

    def save(self, *args, **kwargs):
        if self.variant and self.variant.price:
            self.unit_price = self.variant.price
        else:
            self.unit_price = self.product.price
        self.total_price = self.unit_price * self.quantity
        super().save(*args, **kwargs)


class Wishlist(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='wishlist',
    )

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'wishlists'
        indexes = [
            models.Index(fields=['user'], name='idx_wishlists_user'),
        ]

    def __str__(self):
        return f'Wishlist({self.user.email})'


class WishlistItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    wishlist = models.ForeignKey(Wishlist, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(
        'products.Product',
        on_delete=models.CASCADE,
        related_name='wishlist_items',
    )

    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'wishlist_items'
        unique_together = [('wishlist', 'product')]
        indexes = [
            models.Index(fields=['wishlist'], name='idx_wishlist_items_wishlist'),
            models.Index(fields=['product'], name='idx_wishlist_items_product'),
        ]

    def __str__(self):
        return f'{self.product.name} in {self.wishlist}'
