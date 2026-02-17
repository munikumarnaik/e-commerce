import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/product_repository.dart';

class WishlistNotifier extends StateNotifier<Set<String>> {
  final ProductRepository _repository;

  WishlistNotifier(this._repository) : super({});

  Future<void> loadWishlist() async {
    try {
      final ids = await _repository.getWishlistProductIds();
      state = ids.toSet();
    } catch (_) {
      // Silently fail — wishlist is non-critical
    }
  }

  bool isWishlisted(String productId) => state.contains(productId);

  Future<void> toggle(String productId) async {
    final wasWishlisted = state.contains(productId);

    // Optimistic update
    if (wasWishlisted) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }

    try {
      if (wasWishlisted) {
        await _repository.removeFromWishlist(productId);
      } else {
        await _repository.addToWishlist(productId);
      }
    } catch (_) {
      // Revert on failure
      if (wasWishlisted) {
        state = {...state, productId};
      } else {
        state = {...state}..remove(productId);
      }
    }
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, Set<String>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final notifier = WishlistNotifier(repository);
  notifier.loadWishlist();
  return notifier;
});
