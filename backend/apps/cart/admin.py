from django.contrib import admin

from apps.cart.models import Cart, CartItem, Wishlist, WishlistItem


class CartItemInline(admin.TabularInline):
    model = CartItem
    extra = 0
    readonly_fields = ('unit_price', 'total_price', 'created_at')
    raw_id_fields = ('product', 'variant')


@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    list_display = ('user', 'items_count', 'subtotal', 'total', 'expires_at', 'updated_at')
    list_filter = ('created_at',)
    search_fields = ('user__email', 'user__username')
    readonly_fields = ('subtotal', 'tax', 'discount', 'total', 'created_at', 'updated_at')
    raw_id_fields = ('user',)
    inlines = [CartItemInline]


class WishlistItemInline(admin.TabularInline):
    model = WishlistItem
    extra = 0
    readonly_fields = ('created_at',)
    raw_id_fields = ('product',)


@admin.register(Wishlist)
class WishlistAdmin(admin.ModelAdmin):
    list_display = ('user', 'item_count', 'created_at', 'updated_at')
    search_fields = ('user__email', 'user__username')
    readonly_fields = ('created_at', 'updated_at')
    raw_id_fields = ('user',)
    inlines = [WishlistItemInline]

    def item_count(self, obj):
        return obj.items.count()
    item_count.short_description = 'Items'
