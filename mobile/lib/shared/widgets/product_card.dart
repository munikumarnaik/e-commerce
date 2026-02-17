import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../features/product/domain/models/product_model.dart';
import 'cached_image.dart';
import 'price_widget.dart';
import 'rating_widget.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFood = product.productType == 'FOOD';

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
            // Image section
            Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: CachedImage(
                    imageUrl: product.thumbnail,
                    height: 160,
                    width: double.infinity,
                    borderRadius: AppDimensions.radiusMd,
                    fit: BoxFit.cover,
                  ),
                ),
                // Wishlist heart
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.sm,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: isWishlisted
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                // Food type badge
                if (isFood && product.foodDetails?.foodType != null)
                  Positioned(
                    top: AppDimensions.sm,
                    left: AppDimensions.sm,
                    child: _FoodTypeBadge(
                      foodType: product.foodDetails!.foodType!,
                    ),
                  ),
                // Discount badge
                if (product.discountPercentage != null &&
                    (double.tryParse(product.discountPercentage!) ?? 0) > 0)
                  Positioned(
                    bottom: AppDimensions.sm,
                    left: AppDimensions.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${double.tryParse(product.discountPercentage!)?.toStringAsFixed(0)}% OFF',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Info section
            Padding(
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.xs),
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
          ],
        ),
      ),
    );
  }
}

class _FoodTypeBadge extends StatelessWidget {
  final String foodType;

  const _FoodTypeBadge({required this.foodType});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (foodType) {
      'VEG' => (Colors.green, 'Veg'),
      'NON_VEG' => (Colors.red, 'Non-Veg'),
      'VEGAN' => (Colors.green.shade700, 'Vegan'),
      'EGG' => (Colors.orange, 'Egg'),
      _ => (Colors.grey, foodType),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
