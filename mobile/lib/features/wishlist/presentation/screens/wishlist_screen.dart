import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/price_widget.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../product/domain/models/product_model.dart';
import '../../../product/presentation/providers/wishlist_provider.dart';
import '../providers/wishlist_products_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProductsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          wishlistState.status == WishlistProductsStatus.loaded &&
                  wishlistState.products.isNotEmpty
              ? 'Wishlist (${wishlistState.products.length})'
              : 'Wishlist',
        ),
      ),
      body: _buildBody(context, ref, wishlistState, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WishlistProductsState wishlistState,
    ThemeData theme,
  ) {
    switch (wishlistState.status) {
      case WishlistProductsStatus.initial:
      case WishlistProductsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case WishlistProductsStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.error.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppDimensions.md),
              Text('Failed to load wishlist', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              CustomButton(
                label: 'Retry',
                onPressed: () =>
                    ref.read(wishlistProductsProvider.notifier).loadProducts(),
                fullWidth: false,
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        );

      case WishlistProductsStatus.loaded:
        if (wishlistState.products.isEmpty) {
          return EmptyStateWidget(
            title: 'Nothing saved yet',
            subtitle:
                'Tap the heart on products you love\nand they\'ll appear here.',
            icon: Icons.favorite_border_rounded,
            actionLabel: 'Browse Products',
            onAction: () {},
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(wishlistProductsProvider.notifier).loadProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: AppDimensions.sm + 4,
              mainAxisSpacing: AppDimensions.sm + 4,
            ),
            itemCount: wishlistState.products.length,
            itemBuilder: (context, index) {
              final product = wishlistState.products[index];
              return _WishlistProductCard(
                product: product,
                onTap: () => context.push('/products/${product.slug}'),
                onRemove: () {
                  HapticFeedback.lightImpact();
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                  ref
                      .read(wishlistProductsProvider.notifier)
                      .removeProduct(product.id);
                },
                onMoveToCart: () {
                  HapticFeedback.mediumImpact();
                  ref.read(cartProvider.notifier).addToCart(
                        productId: product.id,
                      );
                  ref.read(wishlistProvider.notifier).toggle(product.id);
                  ref
                      .read(wishlistProductsProvider.notifier)
                      .removeProduct(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} moved to cart'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        );
    }
  }
}

class _WishlistProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMoveToCart;

  const _WishlistProductCard({
    required this.product,
    required this.onTap,
    required this.onRemove,
    required this.onMoveToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with remove button
            Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: CachedImage(
                    imageUrl: product.thumbnail,
                    height: 150,
                    width: double.infinity,
                    borderRadius: AppDimensions.radiusMd,
                    fit: BoxFit.cover,
                  ),
                ),
                // Remove (heart) button
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.sm,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 18,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
                // Out of stock overlay
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm + 4,
                          vertical: AppDimensions.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: Text(
                          'Out of Stock',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.brand != null)
                      Text(
                        product.brand!.name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    RatingWidget(
                      rating: product.averageRating,
                      totalReviews: product.totalReviews,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    PriceWidget(
                      price: product.price,
                      compareAtPrice: product.compareAtPrice,
                    ),
                  ],
                ),
              ),
            ),

            // Move to cart button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.sm,
                0,
                AppDimensions.sm,
                AppDimensions.sm,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton.icon(
                  onPressed: product.isAvailable ? onMoveToCart : null,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                  label: Text(
                    'Move to Cart',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    side: BorderSide(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
