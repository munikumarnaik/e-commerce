import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../product/domain/models/product_model.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../../../product/presentation/providers/wishlist_provider.dart';
import '../../../product/presentation/widgets/product_card_skeleton.dart';

class ProductGridSection extends ConsumerWidget {
  final void Function(Product product)? onProductTap;

  const ProductGridSection({super.key, this.onProductTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(homeProductListProvider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text(
            'All Products',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),

        // Content
        _buildContent(context, ref, productState, wishlist),

        // Loading more indicator
        if (productState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(AppDimensions.md),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ProductListState state,
    Set<String> wishlist,
  ) {
    switch (state.status) {
      case ProductListStatus.initial:
      case ProductListStatus.loading:
        return const ProductGridSkeleton(itemCount: 4);

      case ProductListStatus.error:
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.md),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.read(homeProductListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case ProductListStatus.loaded:
        if (state.products.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Center(
              child: Text(
                'No products found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: AppDimensions.sm,
            mainAxisSpacing: AppDimensions.sm,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              isWishlisted: wishlist.contains(product.id),
              onTap: () => onProductTap?.call(product),
              onWishlistTap: () =>
                  ref.read(wishlistProvider.notifier).toggle(product.id),
            );
          },
        );
    }
  }
}
