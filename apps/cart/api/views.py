from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.cart import services
from apps.cart.api.serializers import (
    AddToCartSerializer,
    AddToWishlistSerializer,
    CartItemSerializer,
    CartSerializer,
    CartSummarySerializer,
    MoveToCartSerializer,
    UpdateCartItemSerializer,
    WishlistSerializer,
)


# ──────────────────────────────────────────────
# Cart Views
# ──────────────────────────────────────────────
class CartView(APIView):
    """GET /cart/ — Retrieve the current user's cart."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        cart = services.get_or_create_cart(request.user)
        serializer = CartSerializer(cart)
        return Response({
            'success': True,
            'data': serializer.data,
            'message': 'Cart retrieved successfully.',
        })


class CartAddView(APIView):
    """POST /cart/add/ — Add an item to the cart."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = AddToCartSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        cart_item = services.add_to_cart(
            user=request.user,
            product_id=serializer.validated_data['product_id'],
            variant_id=serializer.validated_data.get('variant_id'),
            quantity=serializer.validated_data.get('quantity', 1),
        )

        cart = cart_item.cart
        return Response({
            'success': True,
            'data': {
                'cart_item': CartItemSerializer(cart_item).data,
                'cart_summary': {
                    'items_count': cart.items_count,
                    'total': str(cart.total),
                },
            },
            'message': 'Item added to cart.',
        }, status=status.HTTP_201_CREATED)


class CartItemUpdateView(APIView):
    """PATCH /cart/items/{item_id}/ — Update cart item quantity."""
    permission_classes = [IsAuthenticated]

    def patch(self, request, *args, **kwargs):
        serializer = UpdateCartItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        item_id = kwargs.get('item_id')
        quantity = serializer.validated_data['quantity']

        cart_item = services.update_cart_item(
            user=request.user,
            item_id=item_id,
            quantity=quantity,
        )

        cart = services.get_or_create_cart(request.user)
        data = {
            'cart_summary': {
                'items_count': cart.items_count,
                'total': str(cart.total),
            },
        }
        if cart_item:
            data['cart_item'] = CartItemSerializer(cart_item).data

        return Response({
            'success': True,
            'data': data,
            'message': 'Cart updated.',
        })


class CartItemDeleteView(APIView):
    """DELETE /cart/items/{item_id}/ — Remove an item from the cart."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        item_id = kwargs.get('item_id')
        services.remove_cart_item(user=request.user, item_id=item_id)
        return Response(status=status.HTTP_204_NO_CONTENT)


class CartClearView(APIView):
    """DELETE /cart/clear/ — Clear entire cart."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        services.clear_cart(user=request.user)
        return Response(status=status.HTTP_204_NO_CONTENT)


# ──────────────────────────────────────────────
# Wishlist Views
# ──────────────────────────────────────────────
class WishlistView(APIView):
    """GET /wishlist/ — Retrieve the current user's wishlist."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        wishlist = services.get_or_create_wishlist(request.user)
        serializer = WishlistSerializer(wishlist)
        return Response({
            'success': True,
            'data': serializer.data,
            'message': 'Wishlist retrieved successfully.',
        })


class WishlistAddView(APIView):
    """POST /wishlist/add/ — Add a product to the wishlist."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = AddToWishlistSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        services.add_to_wishlist(
            user=request.user,
            product_id=serializer.validated_data['product_id'],
        )

        return Response({
            'success': True,
            'message': 'Added to wishlist.',
        }, status=status.HTTP_201_CREATED)


class WishlistRemoveView(APIView):
    """DELETE /wishlist/remove/{product_id}/ — Remove a product from the wishlist."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        product_id = kwargs.get('product_id')
        services.remove_from_wishlist(user=request.user, product_id=product_id)
        return Response(status=status.HTTP_204_NO_CONTENT)


class WishlistMoveToCartView(APIView):
    """POST /wishlist/move-to-cart/{product_id}/ — Move a wishlist item to cart."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        product_id = kwargs.get('product_id')
        serializer = MoveToCartSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        services.move_wishlist_to_cart(
            user=request.user,
            product_id=product_id,
            variant_id=serializer.validated_data.get('variant_id'),
            quantity=serializer.validated_data.get('quantity', 1),
        )

        return Response({
            'success': True,
            'message': 'Item moved to cart.',
        })


class WishlistClearView(APIView):
    """DELETE /wishlist/clear/ — Clear the wishlist."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        services.clear_wishlist(user=request.user)
        return Response(status=status.HTTP_204_NO_CONTENT)
