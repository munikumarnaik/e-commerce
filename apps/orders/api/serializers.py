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


class ApplyCouponSerializer(serializers.Serializer):
    coupon_code = serializers.CharField(max_length=50)


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
