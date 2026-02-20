import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../domain/models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> wishlistedIds;
  final void Function(Product product)? onProductTap;
  final void Function(String productId)? onWishlistTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ProductGrid({
    super.key,
    required this.products,
    this.wishlistedIds = const {},
    this.onProductTap,
    this.onWishlistTap,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? const EdgeInsets.all(AppDimensions.md),
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
          isWishlisted: wishlistedIds.contains(product.id),
          onTap: () => onProductTap?.call(product),
          onWishlistTap: () => onWishlistTap?.call(product.id),
        );
      },
    );
  }
}

/// Sliver version for use in CustomScrollView
class SliverProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> wishlistedIds;
  final void Function(Product product)? onProductTap;
  final void Function(String productId)? onWishlistTap;

  const SliverProductGrid({
    super.key,
    required this.products,
    this.wishlistedIds = const {},
    this.onProductTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: AppDimensions.sm,
          mainAxisSpacing: AppDimensions.sm,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              isWishlisted: wishlistedIds.contains(product.id),
              onTap: () => onProductTap?.call(product),
              onWishlistTap: () => onWishlistTap?.call(product.id),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
