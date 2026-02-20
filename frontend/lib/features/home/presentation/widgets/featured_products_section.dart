import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../../../product/domain/models/product_model.dart';
import '../../../product/presentation/providers/featured_products_provider.dart';
import '../../../product/presentation/providers/wishlist_provider.dart';

class FeaturedProductsSection extends ConsumerWidget {
  final void Function(Product product)? onProductTap;
  final VoidCallback? onViewAllTap;

  const FeaturedProductsSection({
    super.key,
    this.onProductTap,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(homeFeaturedProductsProvider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.todaysSpecials,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onViewAllTap != null)
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Text(
                    AppStrings.viewAll,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.sm),

        // Horizontal product list
        SizedBox(
          height: 280,
          child: featuredAsync.when(
            data: (products) => products.isEmpty
                ? Center(
                    child: Text(
                      'No featured products yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                    ),
                    itemCount: products.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        width: 170,
                        child: ProductCard(
                          product: product,
                          isWishlisted: wishlist.contains(product.id),
                          onTap: () => onProductTap?.call(product),
                          onWishlistTap: () => ref
                              .read(wishlistProvider.notifier)
                              .toggle(product.id),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                          .slideX(begin: 0.1);
                    },
                  ),
            loading: () => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              itemCount: 4,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.sm),
              itemBuilder: (_, __) => SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      height: 160,
                      width: 170,
                      borderRadius: AppDimensions.radiusMd,
                    ),
                    const SizedBox(height: 8),
                    ShimmerWidget(height: 12, width: 120),
                    const SizedBox(height: 4),
                    ShimmerWidget(height: 14, width: 150),
                    const SizedBox(height: 6),
                    ShimmerWidget(height: 12, width: 80),
                  ],
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
