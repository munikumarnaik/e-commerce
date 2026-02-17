from django.contrib import admin

from apps.orders.models import Coupon, Order, OrderItem, OrderStatusHistory


@admin.register(Coupon)
class CouponAdmin(admin.ModelAdmin):
    list_display = ('code', 'discount_type', 'discount_value', 'max_discount',
                    'usage_count', 'max_usage', 'is_active', 'valid_from', 'valid_until')
    list_filter = ('discount_type', 'is_active')
    search_fields = ('code',)
    readonly_fields = ('usage_count', 'created_at', 'updated_at')


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = ('product_name', 'product_image', 'sku', 'variant_size',
                       'variant_color', 'quantity', 'unit_price', 'total_price', 'vendor')
    raw_id_fields = ('product', 'variant')


class OrderStatusHistoryInline(admin.TabularInline):
    model = OrderStatusHistory
    extra = 0
    readonly_fields = ('status', 'notes', 'changed_by', 'created_at')


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('order_number', 'user', 'status', 'payment_status',
                    'total', 'payment_method', 'created_at')
    list_filter = ('status', 'payment_status', 'payment_method', 'created_at')
    search_fields = ('order_number', 'user__email', 'tracking_number')
    readonly_fields = ('order_number', 'subtotal', 'tax', 'discount', 'total',
                       'shipping_address', 'billing_address', 'created_at', 'updated_at')
    raw_id_fields = ('user', 'coupon')
    inlines = [OrderItemInline, OrderStatusHistoryInline]
    date_hierarchy = 'created_at'
