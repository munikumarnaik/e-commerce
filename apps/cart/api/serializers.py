from rest_framework import serializers

from apps.cart.models import Cart, CartItem, Wishlist, WishlistItem


# ──────────────────────────────────────────────
# Cart Serializers
# ──────────────────────────────────────────────
class CartItemProductSerializer(serializers.Serializer):
    id = serializers.UUIDField()
    name = serializers.CharField()
    slug = serializers.SlugField()
    thumbnail = serializers.URLField()
    is_available = serializers.BooleanField()
    stock_quantity = serializers.IntegerField()


class CartItemVariantSerializer(serializers.Serializer):
    id = serializers.UUIDField()
    size = serializers.CharField()
    color = serializers.CharField()
    color_hex = serializers.CharField()
    stock_quantity = serializers.IntegerField()


class CartItemSerializer(serializers.ModelSerializer):
    product = serializers.SerializerMethodField()
    variant = serializers.SerializerMethodField()

    class Meta:
        model = CartItem
        fields = [
            'id', 'product', 'variant',
            'quantity', 'unit_price', 'total_price',
            'created_at',
        ]

    def get_product(self, obj):
        return {
            'id': str(obj.product.id),
            'name': obj.product.name,
            'slug': obj.product.slug,
            'thumbnail': obj.product.thumbnail,
            'is_available': obj.product.is_available,
            'stock_quantity': obj.product.stock_quantity,
        }

    def get_variant(self, obj):
        if not obj.variant:
            return None
        return {
            'id': str(obj.variant.id),
            'size': obj.variant.size,
            'color': obj.variant.color,
            'color_hex': obj.variant.color_hex,
            'stock_quantity': obj.variant.stock_quantity,
        }


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    items_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = Cart
        fields = [
            'id', 'items', 'items_count',
            'subtotal', 'tax', 'discount', 'total',
            'created_at', 'updated_at',
        ]


class CartSummarySerializer(serializers.Serializer):
    items_count = serializers.IntegerField()
    total = serializers.DecimalField(max_digits=10, decimal_places=2)


class AddToCartSerializer(serializers.Serializer):
    product_id = serializers.UUIDField()
    variant_id = serializers.UUIDField(required=False, allow_null=True)
    quantity = serializers.IntegerField(min_value=1, default=1)


class UpdateCartItemSerializer(serializers.Serializer):
    quantity = serializers.IntegerField(min_value=0)


# ──────────────────────────────────────────────
# Wishlist Serializers
# ──────────────────────────────────────────────
class WishlistItemProductSerializer(serializers.Serializer):
    id = serializers.UUIDField()
    name = serializers.CharField()
    slug = serializers.SlugField()
    thumbnail = serializers.URLField()
    price = serializers.DecimalField(max_digits=10, decimal_places=2)
    compare_at_price = serializers.DecimalField(
        max_digits=10, decimal_places=2, allow_null=True,
    )
    discount_percentage = serializers.DecimalField(max_digits=5, decimal_places=2)
    average_rating = serializers.DecimalField(max_digits=3, decimal_places=2)
    is_available = serializers.BooleanField()
    stock_quantity = serializers.IntegerField()


class WishlistItemSerializer(serializers.ModelSerializer):
    product = serializers.SerializerMethodField()
    added_at = serializers.DateTimeField(source='created_at')

    class Meta:
        model = WishlistItem
        fields = ['id', 'product', 'added_at']

    def get_product(self, obj):
        return {
            'id': str(obj.product.id),
            'name': obj.product.name,
            'slug': obj.product.slug,
            'thumbnail': obj.product.thumbnail,
            'price': str(obj.product.price),
            'compare_at_price': str(obj.product.compare_at_price) if obj.product.compare_at_price else None,
            'discount_percentage': str(obj.product.discount_percentage),
            'average_rating': str(obj.product.average_rating),
            'is_available': obj.product.is_available,
            'stock_quantity': obj.product.stock_quantity,
        }


class WishlistSerializer(serializers.ModelSerializer):
    items = WishlistItemSerializer(many=True, read_only=True)
    count = serializers.SerializerMethodField()

    class Meta:
        model = Wishlist
        fields = ['id', 'count', 'items']

    def get_count(self, obj):
        return obj.items.count()


class AddToWishlistSerializer(serializers.Serializer):
    product_id = serializers.UUIDField()


class MoveToCartSerializer(serializers.Serializer):
    variant_id = serializers.UUIDField(required=False, allow_null=True)
    quantity = serializers.IntegerField(min_value=1, default=1)
