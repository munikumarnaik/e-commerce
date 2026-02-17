import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/product_variant_model.dart';

class VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant? selectedVariant;
  final ValueChanged<ProductVariant> onVariantSelected;

  const VariantSelector({
    super.key,
    required this.variants,
    this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group by type: colors and sizes
    final colors = variants.where((v) => v.color.isNotEmpty).toList();
    final sizes = variants.where((v) => v.size.isNotEmpty).toList();
    final uniqueColors = <String, ProductVariant>{};
    final uniqueSizes = <String, ProductVariant>{};

    for (final v in colors) {
      uniqueColors.putIfAbsent(v.color, () => v);
    }
    for (final v in sizes) {
      uniqueSizes.putIfAbsent(v.size, () => v);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color selection
        if (uniqueColors.isNotEmpty) ...[
          Text(
            AppStrings.selectColor,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            children: uniqueColors.entries.map((entry) {
              final variant = entry.value;
              final isSelected = selectedVariant?.color == entry.key;
              final hexColor = variant.colorHex;

              return GestureDetector(
                onTap: () => onVariantSelected(variant),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: hexColor != null
                        ? _parseHexColor(hexColor)
                        : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: hexColor != null
                              ? (_parseHexColor(hexColor).computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                              : theme.colorScheme.onSurface,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],

        // Size selection
        if (uniqueSizes.isNotEmpty) ...[
          Text(
            AppStrings.selectSize,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            children: uniqueSizes.entries.map((entry) {
              final variant = entry.value;
              final isSelected = selectedVariant?.size == entry.key;
              final isAvailable =
                  variant.stockQuantity > 0 && variant.isActive;

              return GestureDetector(
                onTap: isAvailable ? () => onVariantSelected(variant) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    entry.key,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: !isAvailable
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                          : isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      decoration: !isAvailable
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return Colors.grey;
  }
}
