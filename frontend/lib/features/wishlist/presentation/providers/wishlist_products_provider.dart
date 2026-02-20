import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/models/product_model.dart';
import '../../../product/presentation/providers/wishlist_provider.dart';
import '../../data/repositories/wishlist_repository.dart';

enum WishlistProductsStatus { initial, loading, loaded, error }

class WishlistProductsState {
  final WishlistProductsStatus status;
  final List<Product> products;
  final String? errorMessage;

  const WishlistProductsState({
    this.status = WishlistProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  WishlistProductsState copyWith({
    WishlistProductsStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return WishlistProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage,
    );
  }
}

class WishlistProductsNotifier extends StateNotifier<WishlistProductsState> {
  final WishlistRepository _repository;

  WishlistProductsNotifier(this._repository)
      : super(const WishlistProductsState());

  Future<void> loadProducts() async {
    state = state.copyWith(status: WishlistProductsStatus.loading);
    try {
      final products = await _repository.getWishlistProducts();
      state = state.copyWith(
        status: WishlistProductsStatus.loaded,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(
        status: WishlistProductsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void removeProduct(String productId) {
    state = state.copyWith(
      products: state.products.where((p) => p.id != productId).toList(),
    );
  }
}

final wishlistProductsProvider =
    StateNotifierProvider<WishlistProductsNotifier, WishlistProductsState>(
        (ref) {
  final repository = ref.watch(wishlistRepositoryProvider);
  final notifier = WishlistProductsNotifier(repository);

  // Reload when wishlist IDs change
  ref.listen<Set<String>>(wishlistProvider, (previous, next) {
    if (previous != null && previous != next) {
      notifier.loadProducts();
    }
  });

  notifier.loadProducts();
  return notifier;
});
