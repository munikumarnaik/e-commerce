import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../product/domain/models/product_model.dart';
import '../../../product/presentation/providers/wishlist_provider.dart';

class SearchResultsGrid extends ConsumerWidget {
  final List<Product> products;

  const SearchResultsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: AppDimensions.sm,
        mainAxisSpacing: AppDimensions.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          isWishlisted: wishlist.contains(product.id),
          onTap: () => context.push('/products/${product.slug}'),
          onWishlistTap: () =>
              ref.read(wishlistProvider.notifier).toggle(product.id),
        );
      },
    );
  }
}
