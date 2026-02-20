import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class PriceWidget extends StatelessWidget {
  final String price;
  final String? compareAtPrice;
  final String? discountPercentage;
  final bool large;

  const PriceWidget({
    super.key,
    required this.price,
    this.compareAtPrice,
    this.discountPercentage,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceValue = double.tryParse(price) ?? 0;
    final compareValue = double.tryParse(compareAtPrice ?? '') ?? 0;
    final hasDiscount = compareValue > priceValue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '\u20B9${priceValue.toStringAsFixed(0)}',
          style: (large ? theme.textTheme.titleLarge : theme.textTheme.titleSmall)
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: AppDimensions.xs),
          Text(
            '\u20B9${compareValue.toStringAsFixed(0)}',
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (hasDiscount && discountPercentage != null) ...[
          const SizedBox(width: AppDimensions.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.xs + 2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${double.tryParse(discountPercentage!)?.toStringAsFixed(0)}% OFF',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
