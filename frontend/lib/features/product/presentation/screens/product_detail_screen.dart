import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/providers/available_coupons_provider.dart';
import '../../../../shared/widgets/available_coupons_banner.dart';
import '../../../../shared/widgets/price_widget.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../reviews/presentation/widgets/product_reviews_section.dart';
import '../../domain/models/product_detail_model.dart';
import '../../domain/models/product_variant_model.dart';
import '../providers/product_detail_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/clothing_details_section.dart';
import '../widgets/food_details_section.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/sticky_bottom_bar.dart';
import '../widgets/variant_selector.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ProductVariant? _selectedVariant;
  bool _descriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(productDetailProvider(widget.slug));
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: detailAsync.when(
        data: (product) => _buildContent(context, product, wishlist, theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'Failed to load product',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppDimensions.lg),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.invalidate(productDetailProvider(widget.slug)),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductDetail product,
    Set<String> wishlist,
    ThemeData theme,
  ) {
    final isFood = product.productType == 'FOOD';
    final isWishlisted = wishlist.contains(product.id);
    final isAddingToCart = ref.watch(
      cartProvider.select((s) => s.isAddingToCart),
    );

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Image carousel with back button overlay
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    ProductImageCarousel(
                      images: product.images,
                      thumbnail: product.thumbnail,
                      heroTag: 'product_${product.id}',
                    ),
                    // Top bar overlay
                    Positioned(
                      top: MediaQuery.paddingOf(context).top,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CircleButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            Row(
                              children: [
                                _CircleButton(
                                  icon: Icons.share_outlined,
                                  onTap: () {},
                                ),
                                const SizedBox(width: AppDimensions.sm),
                                _CircleButton(
                                  icon: isWishlisted
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  iconColor: isWishlisted
                                      ? theme.colorScheme.error
                                      : null,
                                  onTap: () => ref
                                      .read(wishlistProvider.notifier)
                                      .toggle(product.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand + Category
                      if (product.brand != null || product.category != null)
                        Row(
                          children: [
                            if (product.brand != null)
                              Text(
                                product.brand!.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (product.brand != null &&
                                product.category != null)
                              Text(
                                '  |  ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                            if (product.category != null)
                              Text(
                                product.category!.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ).animate().fadeIn(duration: 300.ms),

                      const SizedBox(height: AppDimensions.sm),

                      // Name
                      Text(
                        product.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

                      const SizedBox(height: AppDimensions.sm),

                      // Rating
                      RatingWidget(
                        rating: product.averageRating,
                        totalReviews: product.totalReviews,
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                      const SizedBox(height: AppDimensions.md),

                      // Price
                      PriceWidget(
                        price: product.price,
                        compareAtPrice: product.compareAtPrice,
                        large: true,
                      ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

                      // Stock status
                      const SizedBox(height: AppDimensions.sm),
                      _StockStatus(
                        stockQuantity: product.stockQuantity,
                        isAvailable: product.isAvailable,
                      ),

                      const SizedBox(height: AppDimensions.lg),
                    ],
                  ),
                ),
              ),

              // Available coupons
              SliverToBoxAdapter(
                child: _buildCouponsBanner(product.id),
              ),

              // Variants
              if (product.hasVariants)
                SliverToBoxAdapter(
                  child: _buildVariantsSection(theme),
                ),

              // Type-specific details
              if (isFood && product.foodDetails != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                    ),
                    child: FoodDetailsSection(details: product.foodDetails!),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                ),

              if (!isFood && product.clothingDetails != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                    ),
                    child: ClothingDetailsSection(
                      details: product.clothingDetails!,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                ),

              // Description
              if (product.description != null &&
                  product.description!.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildDescription(product.description!, theme),
                ),

              // Vendor info
              // if (product.vendor != null)
              //   SliverToBoxAdapter(
              //     child: _buildVendorInfo(product.vendor!, theme),
              //   ),

              // Inline reviews & ratings
              SliverToBoxAdapter(
                child: ProductReviewsSection(
                  productSlug: product.slug,
                  productName: product.name,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xxl),
              ),
            ],
          ),
        ),

        // Sticky bottom bar
        Builder(builder: (context) {
          final needsVariant = product.hasVariants && _selectedVariant == null;
          return StickyBottomBar(
            isAvailable: product.isAvailable && product.stockQuantity > 0,
            isLoading: isAddingToCart,
            onAddToCart: needsVariant ? null : () => _addToCart(product),
            onBuyNow: needsVariant ? null : () => _buyNow(product),
            disabledMessage:
                needsVariant ? 'Please select size & color first' : null,
          );
        }),
      ],
    );
  }

  Widget _buildVariantsSection(ThemeData theme) {
    final variantsAsync = ref.watch(productVariantsProvider(widget.slug));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: variantsAsync.when(
        data: (variants) => variants.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  VariantSelector(
                    variants: variants,
                    selectedVariant: _selectedVariant,
                    onVariantSelected: (v) =>
                        setState(() => _selectedVariant = v),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ],
              ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppDimensions.md),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCouponsBanner(String productId) {
    final couponsAsync = ref.watch(productCouponsProvider(productId));

    return couponsAsync.when(
      data: (coupons) => coupons.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
              ),
              child: AvailableCouponsBanner(coupons: coupons),
            ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildDescription(String description, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.description,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          AnimatedCrossFade(
            firstChild: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            crossFadeState: _descriptionExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (description.length > 150)
            GestureDetector(
              onTap: () =>
                  setState(() => _descriptionExpanded = !_descriptionExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _descriptionExpanded
                      ? AppStrings.readLess
                      : AppStrings.readMore,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildVendorInfo(ProductVendor vendor, ThemeData theme) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
  //     child: Container(
  //       padding: const EdgeInsets.all(AppDimensions.md),
  //       decoration: BoxDecoration(
  //         color: theme.colorScheme.surfaceContainerHighest,
  //         borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
  //       ),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 20,
  //             backgroundColor: theme.colorScheme.primaryContainer,
  //             child: Text(
  //               vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : 'V',
  //               style: theme.textTheme.titleMedium?.copyWith(
  //                 color: theme.colorScheme.onPrimaryContainer,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: AppDimensions.sm),
  //           // Expanded(
  //           //   child: Column(
  //           //     crossAxisAlignment: CrossAxisAlignment.start,
  //           //     children: [
  //           //       Text(
  //           //         'Sold by',
  //           //         style: theme.textTheme.labelSmall?.copyWith(
  //           //           color: theme.colorScheme.onSurfaceVariant,
  //           //         ),
  //           //       ),
  //           //       Text(
  //           //         vendor.name,
  //           //         style: theme.textTheme.bodyMedium?.copyWith(
  //           //           fontWeight: FontWeight.w600,
  //           //         ),
  //           //       ),
  //           //     ],
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _addToCart(ProductDetail product) async {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    try {
      await ref.read(cartProvider.notifier).addToCart(
            productId: product.id,
            variantId: _selectedVariant?.id,
          );
      if (!mounted) return;
      // Navigate to cart tab after successful add
      context.go(RouteNames.cart);
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Failed to add to cart. Please try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
        ),
      );
    }
  }

  Future<void> _buyNow(ProductDetail product) async {
    await _addToCart(product);
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 22,
          color: iconColor ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _StockStatus extends StatelessWidget {
  final int stockQuantity;
  final bool isAvailable;

  const _StockStatus({
    required this.stockQuantity,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isAvailable || stockQuantity <= 0) {
      return Text(
        AppStrings.outOfStock,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (stockQuantity <= 5) {
      return Text(
        'Only $stockQuantity left in stock',
        style: theme.textTheme.bodySmall?.copyWith(
          color: const Color(0xFFFF6B35),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Text(
      AppStrings.inStock,
      style: theme.textTheme.bodySmall?.copyWith(
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
