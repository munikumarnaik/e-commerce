from django.contrib import admin

from .models import (
    Brand,
    Category,
    ClothingProduct,
    FoodProduct,
    Product,
    ProductImage,
    ProductVariant,
)


class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 1


class ProductVariantInline(admin.TabularInline):
    model = ProductVariant
    extra = 1


class FoodProductInline(admin.StackedInline):
    model = FoodProduct
    can_delete = False
    max_num = 1


class ClothingProductInline(admin.StackedInline):
    model = ClothingProduct
    can_delete = False
    max_num = 1


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'category_type', 'parent', 'display_order', 'is_active')
    list_filter = ('category_type', 'is_active')
    search_fields = ('name', 'slug')
    prepopulated_fields = {'slug': ('name',)}
    ordering = ('display_order', 'name')


@admin.register(Brand)
class BrandAdmin(admin.ModelAdmin):
    list_display = ('name', 'slug', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('name',)
    prepopulated_fields = {'slug': ('name',)}


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = (
        'name', 'sku', 'product_type', 'category', 'price',
        'stock_quantity', 'average_rating', 'is_active', 'is_featured',
    )
    list_filter = ('product_type', 'is_active', 'is_featured', 'is_available', 'category')
    search_fields = ('name', 'sku', 'slug')
    prepopulated_fields = {'slug': ('name',)}
    readonly_fields = ('average_rating', 'total_reviews', 'view_count', 'order_count', 'created_at', 'updated_at')
    inlines = [FoodProductInline, ClothingProductInline, ProductVariantInline, ProductImageInline]

    fieldsets = (
        (None, {'fields': ('name', 'slug', 'sku', 'product_type')}),
        ('Relations', {'fields': ('category', 'brand', 'vendor')}),
        ('Description', {'fields': ('description', 'short_description')}),
        ('Pricing', {'fields': ('price', 'compare_at_price', 'cost_price', 'discount_percentage')}),
        ('Inventory', {'fields': ('stock_quantity', 'low_stock_threshold', 'track_inventory')}),
        ('Media', {'fields': ('thumbnail',)}),
        ('SEO', {'fields': ('meta_title', 'meta_description'), 'classes': ('collapse',)}),
        ('Stats', {'fields': ('average_rating', 'total_reviews', 'view_count', 'order_count'), 'classes': ('collapse',)}),
        ('Flags', {'fields': ('is_active', 'is_featured', 'is_available')}),
        ('Audit', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )


@admin.register(ProductVariant)
class ProductVariantAdmin(admin.ModelAdmin):
    list_display = ('product', 'sku', 'size', 'color', 'price', 'stock_quantity', 'is_active')
    list_filter = ('is_active',)
    search_fields = ('sku', 'product__name')


@admin.register(ProductImage)
class ProductImageAdmin(admin.ModelAdmin):
    list_display = ('product', 'alt_text', 'display_order', 'is_primary')
    list_filter = ('is_primary',)
    search_fields = ('product__name', 'alt_text')
