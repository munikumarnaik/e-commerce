import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/shimmer_widget.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const ShimmerWidget(
            height: 160,
            borderRadius: AppDimensions.radiusMd,
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                ShimmerWidget(
                  height: 10,
                  width: 60,
                  borderRadius: AppDimensions.radiusSm,
                ),
                const SizedBox(height: 6),
                // Name
                ShimmerWidget(
                  height: 14,
                  borderRadius: AppDimensions.radiusSm,
                ),
                const SizedBox(height: 4),
                ShimmerWidget(
                  height: 14,
                  width: 100,
                  borderRadius: AppDimensions.radiusSm,
                ),
                const SizedBox(height: 8),
                // Rating
                ShimmerWidget(
                  height: 12,
                  width: 80,
                  borderRadius: AppDimensions.radiusSm,
                ),
                const SizedBox(height: 6),
                // Price
                ShimmerWidget(
                  height: 16,
                  width: 70,
                  borderRadius: AppDimensions.radiusSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
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
      itemCount: itemCount,
      itemBuilder: (_, __) => const ProductCardSkeleton(),
    );
  }
}

/// Sliver version for CustomScrollView
class SliverProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const SliverProductGridSkeleton({super.key, this.itemCount = 6});

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
          (_, __) => const ProductCardSkeleton(),
          childCount: itemCount,
        ),
      ),
    );
  }
}
