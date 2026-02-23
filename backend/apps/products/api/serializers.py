from rest_framework import serializers

from apps.products.models import (
    Brand,
    Category,
    ClothingProduct,
    FoodProduct,
    Product,
    ProductImage,
    ProductVariant,
)


# ──────────────────────────────────────────────
# Category Serializers
# ──────────────────────────────────────────────
class SubcategorySerializer(serializers.ModelSerializer):
    product_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'product_count']


class CategoryListSerializer(serializers.ModelSerializer):
    product_count = serializers.IntegerField(read_only=True)
    subcategories = SubcategorySerializer(many=True, read_only=True)

    class Meta:
        model = Category
        fields = [
            'id', 'name', 'slug', 'category_type', 'parent', 'image', 'icon',
            'description', 'display_order', 'product_count', 'subcategories',
        ]


class CategoryDetailSerializer(serializers.ModelSerializer):
    product_count = serializers.IntegerField(read_only=True)
    parent = serializers.SerializerMethodField()
    subcategories = SubcategorySerializer(many=True, read_only=True)

    class Meta:
        model = Category
        fields = [
            'id', 'name', 'slug', 'category_type', 'parent', 'image',
            'description', 'product_count', 'subcategories',
        ]

    def get_parent(self, obj):
        if obj.parent:
            return {'id': str(obj.parent.id), 'name': obj.parent.name, 'slug': obj.parent.slug}
        return None


class CategoryTreeSerializer(serializers.ModelSerializer):
    children = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'icon', 'children']

    def get_children(self, obj):
        children = obj.subcategories.filter(is_active=True).order_by('display_order', 'name')
        return CategoryTreeSerializer(children, many=True).data


class CategoryCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = [
            'name', 'slug', 'category_type', 'parent', 'image', 'icon',
            'description', 'display_order', 'is_active',
        ]
        extra_kwargs = {'slug': {'required': False}}


# ──────────────────────────────────────────────
# Brand Serializers
# ──────────────────────────────────────────────
class BrandSerializer(serializers.ModelSerializer):
    class Meta:
        model = Brand
        fields = ['id', 'name', 'slug', 'logo', 'description', 'is_active']


class BrandCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Brand
        fields = ['name', 'slug', 'logo', 'description', 'is_active']
        extra_kwargs = {'slug': {'required': False}}


# ──────────────────────────────────────────────
# ProductImage Serializer
# ──────────────────────────────────────────────
class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        fields = ['id', 'image_url', 'alt_text', 'display_order', 'is_primary']


# ──────────────────────────────────────────────
# ProductVariant Serializer
# ──────────────────────────────────────────────
class ProductVariantSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductVariant
        fields = [
            'id', 'sku', 'size', 'color', 'color_hex',
            'price', 'stock_quantity', 'image_url', 'is_active',
        ]


class ProductVariantCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductVariant
        fields = [
            'sku', 'size', 'color', 'color_hex',
            'price', 'stock_quantity', 'image_url', 'is_active',
        ]


# ──────────────────────────────────────────────
# FoodProduct Serializer
# ──────────────────────────────────────────────
class FoodProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodProduct
        fields = [
            'food_type', 'cuisine_type', 'spice_level',
            'calories', 'protein', 'carbs', 'fat',
            'serving_size', 'preparation_time',
            'contains_gluten', 'contains_dairy', 'contains_nuts',
            'is_perishable',
        ]


# ──────────────────────────────────────────────
# ClothingProduct Serializer
# ──────────────────────────────────────────────
class ClothingProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = ClothingProduct
        fields = [
            'gender', 'clothing_type', 'material', 'fabric',
            'care_instructions', 'fit_type', 'pattern',
            'length', 'width', 'season',
        ]


# ──────────────────────────────────────────────
# Product List Serializer (compact, for lists)
# ──────────────────────────────────────────────
class ProductListSerializer(serializers.ModelSerializer):
    category = serializers.SerializerMethodField()
    brand = serializers.SerializerMethodField()
    images = ProductImageSerializer(many=True, read_only=True)
    variants_preview = serializers.SerializerMethodField()
    food_details = FoodProductSerializer(read_only=True)
    clothing_details = ClothingProductSerializer(read_only=True)
    has_variants = serializers.BooleanField(read_only=True)

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'sku', 'product_type',
            'category', 'brand',
            'description', 'short_description',
            'price', 'compare_at_price', 'discount_percentage',
            'stock_quantity', 'track_inventory',
            'thumbnail', 'images',
            'average_rating', 'total_reviews',
            'is_featured', 'is_available', 'has_variants',
            'variants_preview',
            'food_details', 'clothing_details',
            'created_at',
        ]

    def get_category(self, obj):
        return {'id': str(obj.category.id), 'name': obj.category.name, 'slug': obj.category.slug}

    def get_brand(self, obj):
        if obj.brand:
            return {'id': str(obj.brand.id), 'name': obj.brand.name, 'logo': obj.brand.logo}
        return None

    def get_variants_preview(self, obj):
        variants = obj.variants.filter(is_active=True)[:5]
        return ProductVariantSerializer(variants, many=True).data


# ──────────────────────────────────────────────
# Product Detail Serializer (full detail)
# ──────────────────────────────────────────────
class ProductDetailSerializer(serializers.ModelSerializer):
    category = serializers.SerializerMethodField()
    brand = serializers.SerializerMethodField()
    vendor = serializers.SerializerMethodField()
    images = ProductImageSerializer(many=True, read_only=True)
    food_details = FoodProductSerializer(read_only=True)
    clothing_details = ClothingProductSerializer(read_only=True)
    has_variants = serializers.BooleanField(read_only=True)
    reviews_summary = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'sku', 'product_type',
            'category', 'brand', 'vendor',
            'description', 'short_description',
            'price', 'compare_at_price', 'discount_percentage',
            'stock_quantity', 'track_inventory',
            'thumbnail', 'images',
            'average_rating', 'total_reviews', 'reviews_summary',
            'food_details', 'clothing_details',
            'is_featured', 'is_available', 'has_variants',
            'view_count', 'created_at',
        ]

    def get_category(self, obj):
        breadcrumb = []
        cat = obj.category
        while cat:
            breadcrumb.insert(0, cat.name)
            cat = cat.parent
        return {
            'id': str(obj.category.id),
            'name': obj.category.name,
            'slug': obj.category.slug,
            'breadcrumb': breadcrumb,
        }

    def get_brand(self, obj):
        if obj.brand:
            return {'id': str(obj.brand.id), 'name': obj.brand.name, 'logo': obj.brand.logo}
        return None

    def get_vendor(self, obj):
        return {
            'id': str(obj.vendor.id),
            'name': obj.vendor.full_name,
            'profile_image': obj.vendor.profile_image,
        }

    def get_reviews_summary(self, obj):
        from apps.reviews.services import get_reviews_summary
        return get_reviews_summary(obj)


# ──────────────────────────────────────────────
# Product Create/Update Serializer
# ──────────────────────────────────────────────
class ProductCreateSerializer(serializers.ModelSerializer):
    food_details = FoodProductSerializer(required=False)
    clothing_details = ClothingProductSerializer(required=False)
    variants = ProductVariantCreateSerializer(many=True, required=False)

    # Accept brand as a plain name string; resolved to a Brand instance in validate()
    brand = serializers.CharField(
        required=False, allow_null=True, allow_blank=True,
    )

    class Meta:
        model = Product
        fields = [
            'name', 'slug', 'sku', 'product_type',
            'category', 'brand',
            'description', 'short_description',
            'price', 'compare_at_price', 'cost_price',
            'stock_quantity', 'low_stock_threshold', 'track_inventory',
            'thumbnail',
            'meta_title', 'meta_description',
            'is_active', 'is_featured', 'is_available',
            'food_details', 'clothing_details', 'variants',
        ]
        extra_kwargs = {
            'slug': {'required': False},
            'thumbnail': {'required': False, 'allow_null': True, 'allow_blank': True},
        }

    def validate(self, attrs):
        product_type = attrs.get('product_type')
        food_details = attrs.get('food_details')
        clothing_details = attrs.get('clothing_details')

        if product_type == 'FOOD' and not food_details:
            raise serializers.ValidationError(
                {'food_details': 'Food details are required for food products.'},
            )
        if product_type == 'CLOTHING' and not clothing_details:
            raise serializers.ValidationError(
                {'clothing_details': 'Clothing details are required for clothing products.'},
            )

        # Admin types a brand name → resolve to Brand instance (create if new)
        brand_name = attrs.get('brand')
        if brand_name and brand_name.strip():
            name = brand_name.strip()
            try:
                brand_obj = Brand.objects.get(name__iexact=name)
            except Brand.DoesNotExist:
                brand_obj = Brand.objects.create(name=name, is_active=True)
            attrs['brand'] = brand_obj
        else:
            attrs['brand'] = None

        return attrs

    def create(self, validated_data):
        food_data = validated_data.pop('food_details', None)
        clothing_data = validated_data.pop('clothing_details', None)
        variants_data = validated_data.pop('variants', [])

        product = Product.objects.create(**validated_data)

        if food_data:
            FoodProduct.objects.create(product=product, **food_data)
        if clothing_data:
            ClothingProduct.objects.create(product=product, **clothing_data)
        for variant_data in variants_data:
            ProductVariant.objects.create(product=product, **variant_data)

        return product

    def update(self, instance, validated_data):
        food_data = validated_data.pop('food_details', None)
        clothing_data = validated_data.pop('clothing_details', None)
        validated_data.pop('variants', None)  # Variants are managed via separate endpoints

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if food_data and instance.product_type == 'FOOD':
            FoodProduct.objects.update_or_create(product=instance, defaults=food_data)
        if clothing_data and instance.product_type == 'CLOTHING':
            ClothingProduct.objects.update_or_create(product=instance, defaults=clothing_data)

        return instance


# ──────────────────────────────────────────────
# Image Upload Serializer
# ──────────────────────────────────────────────
class ImageUploadSerializer(serializers.Serializer):
    image = serializers.ImageField()
    alt_text = serializers.CharField(max_length=255, required=False, default='')
    is_primary = serializers.BooleanField(required=False, default=False)
