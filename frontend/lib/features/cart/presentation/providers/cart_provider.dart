import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/models/cart_model.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState {
  final CartStatus status;
  final Cart cart;
  final String? errorMessage;
  final bool isAddingToCart;
  final bool isCouponLoading;
  final String? couponError;

  const CartState({
    this.status = CartStatus.initial,
    Cart? cart,
    this.errorMessage,
    this.isAddingToCart = false,
    this.isCouponLoading = false,
    this.couponError,
  }) : cart = cart ?? const Cart(id: '');

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
    bool? isAddingToCart,
    bool? isCouponLoading,
    String? couponError,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      isCouponLoading: isCouponLoading ?? this.isCouponLoading,
      couponError: couponError,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const CartState());

  Future<void> loadCart() async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final cart = await _repository.getCart();
      state = state.copyWith(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Adds product to cart. Throws on failure so callers can show error UI.
  Future<void> addToCart({
    required String productId,
    String? variantId,
    int quantity = 1,
  }) async {
    state = state.copyWith(isAddingToCart: true);
    try {
      final cart = await _repository.addToCart(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
      );
      state = state.copyWith(
        status: CartStatus.loaded,
        cart: cart,
        isAddingToCart: false,
      );
    } catch (e) {
      state = state.copyWith(
        isAddingToCart: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity < 1) return;

    // Optimistic update
    final previousCart = state.cart;
    final updatedItems = state.cart.items.map((item) {
      if (item.id == itemId) {
        final newTotal = item.unitPriceValue * quantity;
        return item.copyWith(
          quantity: quantity,
          totalPrice: newTotal.toStringAsFixed(2),
        );
      }
      return item;
    }).toList();

    state = state.copyWith(
      cart: state.cart.copyWith(items: updatedItems),
    );

    try {
      final cart = await _repository.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );
      state = state.copyWith(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      // Revert on failure
      state = state.copyWith(cart: previousCart, errorMessage: e.toString());
    }
  }

  Future<void> removeItem(String itemId) async {
    // Optimistic update
    final previousCart = state.cart;
    final updatedItems =
        state.cart.items.where((item) => item.id != itemId).toList();

    state = state.copyWith(
      cart: state.cart.copyWith(
        items: updatedItems,
        itemCount: updatedItems.length,
      ),
    );

    try {
      final cart = await _repository.removeCartItem(itemId);
      state = state.copyWith(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      // Revert on failure
      state = state.copyWith(cart: previousCart, errorMessage: e.toString());
    }
  }

  Future<void> clearCart() async {
    final previousCart = state.cart;
    state = state.copyWith(cart: Cart.empty());

    try {
      final cart = await _repository.clearCart();
      state = state.copyWith(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(cart: previousCart, errorMessage: e.toString());
    }
  }

  Future<void> applyCoupon(String couponCode) async {
    state = state.copyWith(isCouponLoading: true, couponError: null);
    try {
      final cart = await _repository.applyCoupon(couponCode);
      state = state.copyWith(
        cart: cart,
        isCouponLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCouponLoading: false,
        couponError: 'Invalid coupon code',
      );
    }
  }

  Future<void> removeCoupon() async {
    state = state.copyWith(isCouponLoading: true);
    try {
      final cart = await _repository.removeCoupon();
      state = state.copyWith(cart: cart, isCouponLoading: false);
    } catch (e) {
      state = state.copyWith(
        isCouponLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  final notifier = CartNotifier(repository);
  notifier.loadCart();
  return notifier;
});

/// Derived provider for cart item count (used for badge)
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState.status == CartStatus.loaded) {
    return cartState.cart.itemCount > 0
        ? cartState.cart.itemCount
        : cartState.cart.items.length;
  }
  return 0;
});
