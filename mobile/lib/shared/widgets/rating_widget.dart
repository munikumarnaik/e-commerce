import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final bool compact;

  const RatingWidget({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (rating == 0 && totalReviews == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: compact ? 14 : 18,
          color: Colors.amber,
        ),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: (compact ? theme.textTheme.labelSmall : theme.textTheme.bodyMedium)
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (totalReviews > 0) ...[
          const SizedBox(width: AppDimensions.xs),
          Text(
            '($totalReviews)',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
