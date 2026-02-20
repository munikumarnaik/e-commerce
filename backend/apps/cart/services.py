from decimal import Decimal

from django.db import transaction
from rest_framework.exceptions import ValidationError

from apps.cart.models import Cart, CartItem, Wishlist, WishlistItem
from apps.products.models import Product, ProductVariant


def get_or_create_cart(user):
    """Get or create a cart for the user, resetting if expired."""
    cart, created = Cart.objects.get_or_create(user=user)
    if not created and cart.is_expired:
        cart.clear_items()
    return cart


def get_or_create_wishlist(user):
    """Get or create a wishlist for the user."""
    wishlist, _ = Wishlist.objects.get_or_create(user=user)
    return wishlist


def validate_stock(product, variant, quantity):
    """Validate that sufficient stock exists."""
    if not product.is_active or not product.is_available:
        raise ValidationError({'product': 'This product is not available.'})

    if variant:
        if not variant.is_active:
            raise ValidationError({'variant': 'This variant is not available.'})
        available = variant.stock_quantity
        label = f'{product.name} ({variant.size} {variant.color})'.strip()
    elif product.track_inventory:
        available = product.stock_quantity
        label = product.name
    else:
        return  # No inventory tracking

    if quantity > available:
        if available == 0:
            raise ValidationError({'stock': f'{label} is out of stock.'})
        raise ValidationError(
            {'stock': f'Only {available} items available for {label}.'},
        )


@transaction.atomic
def add_to_cart(user, product_id, variant_id=None, quantity=1):
    """Add a product to the user's cart."""
    cart = get_or_create_cart(user)

    try:
        product = Product.objects.get(id=product_id, is_active=True, is_available=True)
    except Product.DoesNotExist:
        raise ValidationError({'product': 'Product not found or unavailable.'})

    variant = None
    if variant_id:
        try:
            variant = ProductVariant.objects.get(
                id=variant_id, product=product, is_active=True,
            )
        except ProductVariant.DoesNotExist:
            raise ValidationError({'variant': 'Variant not found or unavailable.'})

    # Check if product has variants but none specified
    if product.variants.filter(is_active=True).exists() and not variant:
        raise ValidationError({'variant': 'Please select a variant for this product.'})

    # Check existing cart item
    try:
        cart_item = CartItem.objects.get(cart=cart, product=product, variant=variant)
        new_quantity = cart_item.quantity + quantity
        validate_stock(product, variant, new_quantity)
        cart_item.quantity = new_quantity
        cart_item.save()
    except CartItem.DoesNotExist:
        validate_stock(product, variant, quantity)
        cart_item = CartItem(
            cart=cart,
            product=product,
            variant=variant,
            quantity=quantity,
        )
        cart_item.save()

    cart.recalculate()
    return cart_item


@transaction.atomic
def update_cart_item(user, item_id, quantity):
    """Update cart item quantity."""
    cart = get_or_create_cart(user)

    try:
        cart_item = CartItem.objects.select_related('product', 'variant').get(
            id=item_id, cart=cart,
        )
    except CartItem.DoesNotExist:
        raise ValidationError({'item': 'Cart item not found.'})

    if quantity <= 0:
        cart_item.delete()
    else:
        validate_stock(cart_item.product, cart_item.variant, quantity)
        cart_item.quantity = quantity
        cart_item.save()

    cart.recalculate()
    return cart_item if quantity > 0 else None


@transaction.atomic
def remove_cart_item(user, item_id):
    """Remove an item from the cart."""
    cart = get_or_create_cart(user)

    try:
        cart_item = CartItem.objects.get(id=item_id, cart=cart)
    except CartItem.DoesNotExist:
        raise ValidationError({'item': 'Cart item not found.'})

    cart_item.delete()
    cart.recalculate()


@transaction.atomic
def clear_cart(user):
    """Clear all items from the cart."""
    cart = get_or_create_cart(user)
    cart.clear_items()


@transaction.atomic
def add_to_wishlist(user, product_id):
    """Add a product to the user's wishlist."""
    wishlist = get_or_create_wishlist(user)

    try:
        product = Product.objects.get(id=product_id, is_active=True)
    except Product.DoesNotExist:
        raise ValidationError({'product': 'Product not found.'})

    _, created = WishlistItem.objects.get_or_create(
        wishlist=wishlist,
        product=product,
    )

    if not created:
        raise ValidationError({'product': 'Product is already in your wishlist.'})

    return wishlist


@transaction.atomic
def remove_from_wishlist(user, product_id):
    """Remove a product from the user's wishlist."""
    wishlist = get_or_create_wishlist(user)

    try:
        item = WishlistItem.objects.get(wishlist=wishlist, product_id=product_id)
    except WishlistItem.DoesNotExist:
        raise ValidationError({'product': 'Product not found in your wishlist.'})

    item.delete()


@transaction.atomic
def clear_wishlist(user):
    """Clear all items from the wishlist."""
    wishlist = get_or_create_wishlist(user)
    wishlist.items.all().delete()


@transaction.atomic
def move_wishlist_to_cart(user, product_id, variant_id=None, quantity=1):
    """Move a product from wishlist to cart."""
    wishlist = get_or_create_wishlist(user)

    try:
        wishlist_item = WishlistItem.objects.get(
            wishlist=wishlist, product_id=product_id,
        )
    except WishlistItem.DoesNotExist:
        raise ValidationError({'product': 'Product not found in your wishlist.'})

    cart_item = add_to_cart(user, product_id, variant_id=variant_id, quantity=quantity)
    wishlist_item.delete()

    return cart_item
