from rest_framework import serializers

from apps.orders.models import Coupon, Order, OrderItem, OrderStatusHistory


# ──────────────────────────────────────────────
# Coupon Serializers
# ──────────────────────────────────────────────
class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = [
            'id', 'code', 'discount_type', 'discount_value',
            'max_discount', 'min_order_value',
            'valid_from', 'valid_until', 'is_active',
        ]


class PublicCouponSerializer(serializers.ModelSerializer):
    applicable_products = serializers.SerializerMethodField()

    class Meta:
        model = Coupon
        fields = [
            'id', 'code', 'discount_type', 'discount_value',
            'max_discount', 'min_order_value',
            'valid_from', 'valid_until', 'applicable_products',
        ]

    def get_applicable_products(self, obj):
        return [str(p.id) for p in obj.applicable_products.all()]


class ApplyCouponSerializer(serializers.Serializer):
    coupon_code = serializers.CharField(max_length=50)


class AdminCouponSerializer(serializers.ModelSerializer):
    is_valid = serializers.BooleanField(read_only=True)
    applicable_products = serializers.SerializerMethodField()

    class Meta:
        model = Coupon
        fields = [
            'id', 'code', 'discount_type', 'discount_value',
            'max_discount', 'min_order_value', 'max_usage', 'usage_per_user',
            'usage_count', 'valid_from', 'valid_until',
            'is_active', 'is_valid', 'applicable_products', 'created_at',
        ]

    def get_applicable_products(self, obj):
        return [
            {'id': str(p.id), 'name': p.name, 'slug': p.slug}
            for p in obj.applicable_products.all()
        ]


class AdminCouponCreateSerializer(serializers.ModelSerializer):
    product_ids = serializers.ListField(
        child=serializers.UUIDField(), required=False, write_only=True,
    )

    class Meta:
        model = Coupon
        fields = [
            'code', 'discount_type', 'discount_value',
            'max_discount', 'min_order_value', 'max_usage', 'usage_per_user',
            'valid_from', 'valid_until', 'is_active', 'product_ids',
        ]

    def validate_code(self, value):
        return value.upper().strip()

    def create(self, validated_data):
        product_ids = validated_data.pop('product_ids', [])
        coupon = super().create(validated_data)
        if product_ids:
            coupon.applicable_products.set(product_ids)
        return coupon

    def update(self, instance, validated_data):
        product_ids = validated_data.pop('product_ids', None)
        coupon = super().update(instance, validated_data)
        if product_ids is not None:
            coupon.applicable_products.set(product_ids)
        return coupon


# ──────────────────────────────────────────────
# Order Serializers
# ──────────────────────────────────────────────
class OrderItemSerializer(serializers.ModelSerializer):
    vendor = serializers.SerializerMethodField()

    class Meta:
        model = OrderItem
        fields = [
            'id', 'product_name', 'product_image', 'sku',
            'variant_size', 'variant_color',
            'quantity', 'unit_price', 'total_price', 'discount',
            'vendor',
        ]

    def get_vendor(self, obj):
        return {
            'id': str(obj.vendor.id),
            'name': obj.vendor.full_name,
        }


class OrderStatusHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderStatusHistory
        fields = ['status', 'notes', 'created_at']


class OrderListSerializer(serializers.ModelSerializer):
    items_count = serializers.SerializerMethodField()
    items_preview = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'status', 'payment_status',
            'total', 'items_count', 'items_preview',
            'created_at', 'estimated_delivery', 'delivered_at',
        ]

    def get_items_count(self, obj):
        return obj.items.count()

    def get_items_preview(self, obj):
        items = obj.items.all()[:3]
        return [
            {
                'product_name': item.product_name,
                'product_image': item.product_image,
                'quantity': item.quantity,
            }
            for item in items
        ]


class OrderDetailSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    status_history = OrderStatusHistorySerializer(many=True, read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'status', 'payment_status',
            'items',
            'subtotal', 'tax', 'shipping_cost', 'discount', 'total',
            'shipping_address', 'billing_address',
            'payment_method', 'payment_id', 'transaction_id',
            'tracking_number', 'estimated_delivery', 'delivered_at',
            'customer_note',
            'status_history',
            'created_at', 'updated_at',
        ]


class CreateOrderSerializer(serializers.Serializer):
    shipping_address_id = serializers.UUIDField()
    billing_address_id = serializers.UUIDField(required=False, allow_null=True)
    payment_method = serializers.CharField(max_length=50, default='cod')
    customer_note = serializers.CharField(required=False, allow_blank=True, default='')
    coupon_code = serializers.CharField(required=False, allow_blank=True, default='')


class CancelOrderSerializer(serializers.Serializer):
    reason = serializers.CharField(required=False, allow_blank=True, default='')


class OrderTrackSerializer(serializers.ModelSerializer):
    timeline = OrderStatusHistorySerializer(source='status_history', many=True, read_only=True)

    class Meta:
        model = Order
        fields = [
            'order_number', 'status', 'tracking_number',
            'estimated_delivery', 'timeline',
        ]


# ──────────────────────────────────────────────
# Admin Serializers
# ──────────────────────────────────────────────
class AdminOrderListSerializer(serializers.ModelSerializer):
    customer = serializers.SerializerMethodField()
    items_count = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'status', 'payment_status',
            'total', 'payment_method', 'customer', 'items_count',
            'tracking_number', 'created_at', 'updated_at',
        ]

    def get_customer(self, obj):
        return {
            'id': str(obj.user.id),
            'name': obj.user.full_name,
            'email': obj.user.email,
        }

    def get_items_count(self, obj):
        return obj.items.count()


class AdminUpdateOrderStatusSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=Order.Status.choices)
    tracking_number = serializers.CharField(required=False, allow_blank=True, default='')
    notes = serializers.CharField(required=False, allow_blank=True, default='')


# ──────────────────────────────────────────────
# Vendor Serializers
# ──────────────────────────────────────────────
class VendorOrderItemSerializer(serializers.ModelSerializer):
    order_number = serializers.CharField(source='order.order_number', read_only=True)
    order_status = serializers.CharField(source='order.status', read_only=True)
    customer_name = serializers.SerializerMethodField()
    shipping_address = serializers.JSONField(source='order.shipping_address', read_only=True)

    class Meta:
        model = OrderItem
        fields = [
            'id', 'order_number', 'order_status',
            'product_name', 'product_image', 'sku',
            'variant_size', 'variant_color',
            'quantity', 'unit_price', 'total_price',
            'customer_name', 'shipping_address',
            'created_at',
        ]

    def get_customer_name(self, obj):
        return obj.order.user.full_name
