import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const ShimmerWidget({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  const ShimmerWidget.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 100;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
