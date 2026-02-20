import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../../../product/presentation/widgets/product_card_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.md),

          // Greeting skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(height: 16, width: 140),
                const SizedBox(height: 6),
                ShimmerWidget(height: 24, width: 200),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Category toggle skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: ShimmerWidget(
              height: 48,
              borderRadius: AppDimensions.radiusLg,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Search bar skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: ShimmerWidget(
              height: 48,
              borderRadius: AppDimensions.radiusMd,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Banner skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: ShimmerWidget(
              height: 160,
              borderRadius: AppDimensions.radiusLg,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Category chips skeleton
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              itemCount: 6,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.sm),
              itemBuilder: (_, __) => Column(
                children: [
                  ShimmerWidget.circular(size: 60),
                  const SizedBox(height: 6),
                  ShimmerWidget(height: 10, width: 50),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Featured section title skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: ShimmerWidget(height: 18, width: 150),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Featured products skeleton
          SizedBox(
            height: 240,
            child: ListView.separated(
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
          ),
          const SizedBox(height: AppDimensions.lg),

          // Product grid skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: ShimmerWidget(height: 18, width: 120),
          ),
          const SizedBox(height: AppDimensions.sm),
          const ProductGridSkeleton(itemCount: 4),
        ],
      ),
    );
  }
}
