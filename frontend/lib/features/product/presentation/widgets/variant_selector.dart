import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/product_variant_model.dart';

class VariantSelector extends StatefulWidget {
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
  State<VariantSelector> createState() => _VariantSelectorState();
}

class _VariantSelectorState extends State<VariantSelector> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    final sv = widget.selectedVariant;
    _selectedSize = (sv != null && sv.size.isNotEmpty) ? sv.size : null;
    _selectedColor = (sv != null && sv.color.isNotEmpty) ? sv.color : null;
  }

  void _onColorTap(String color) {
    setState(() => _selectedColor = color);
    _notifyIfMatch(size: _selectedSize, color: color);
  }

  void _onSizeTap(String size) {
    setState(() => _selectedSize = size);
    _notifyIfMatch(size: size, color: _selectedColor);
  }

  /// Find variant matching the given size+color and notify parent.
  void _notifyIfMatch({required String? size, required String? color}) {
    final match = _findVariant(size: size, color: color);
    if (match != null) widget.onVariantSelected(match);
  }

  ProductVariant? _findVariant({required String? size, required String? color}) {
    if (size != null && color != null) {
      for (final v in widget.variants) {
        if (v.size == size && v.color == color) return v;
      }
      // Fall back to size-only match if no color variants exist for this size
      for (final v in widget.variants) {
        if (v.size == size && v.color.isEmpty) return v;
      }
      return null;
    }
    if (size != null) {
      for (final v in widget.variants) {
        if (v.size == size) return v;
      }
    }
    if (color != null) {
      for (final v in widget.variants) {
        if (v.color == color) return v;
      }
    }
    return null;
  }

  bool _isSizeAvailable(String size) {
    if (_selectedColor != null) {
      return widget.variants.any(
        (v) =>
            v.size == size &&
            v.color == _selectedColor &&
            v.stockQuantity > 0 &&
            v.isActive,
      );
    }
    return widget.variants
        .any((v) => v.size == size && v.stockQuantity > 0 && v.isActive);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final uniqueColors = <String, ProductVariant>{};
    final uniqueSizes = <String, ProductVariant>{};
    for (final v in widget.variants) {
      if (v.color.isNotEmpty) uniqueColors.putIfAbsent(v.color, () => v);
      if (v.size.isNotEmpty) uniqueSizes.putIfAbsent(v.size, () => v);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Color selection ──────────────────────────────────────
        if (uniqueColors.isNotEmpty) ...[
          Text(
            AppStrings.selectColor,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: uniqueColors.entries.map((entry) {
              final variant = entry.value;
              final isSelected = _selectedColor == entry.key;
              final resolvedColor = _resolveColor(variant);

              return GestureDetector(
                onTap: () => _onColorTap(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: resolvedColor ??
                        theme.colorScheme.surfaceContainerHighest,
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
                          color: resolvedColor != null
                              ? (resolvedColor.computeLuminance() > 0.5
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

        // ── Size selection ───────────────────────────────────────
        if (uniqueSizes.isNotEmpty) ...[
          Text(
            AppStrings.selectSize,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: uniqueSizes.entries.map((entry) {
              final isSelected = _selectedSize == entry.key;
              final isAvailable = _isSizeAvailable(entry.key);

              return GestureDetector(
                onTap: isAvailable ? () => _onSizeTap(entry.key) : null,
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
                      decoration:
                          !isAvailable ? TextDecoration.lineThrough : null,
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

  /// Returns a [Color] for a variant's color field.
  /// Uses [colorHex] when available, otherwise looks up the color name.
  Color? _resolveColor(ProductVariant variant) {
    final hex = variant.colorHex ?? _colorNameToHex[variant.color.toLowerCase()];
    if (hex == null) return null;
    return _parseHexColor(hex);
  }

  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return Colors.grey;
  }

  static const _colorNameToHex = {
    'black':  '#000000',
    'white':  '#FFFFFF',
    'red':    '#F44336',
    'blue':   '#2196F3',
    'navy':   '#001F5B',
    'green':  '#4CAF50',
    'yellow': '#FFEB3B',
    'pink':   '#E91E8C',
    'purple': '#9C27B0',
    'brown':  '#795548',
    'grey':   '#9E9E9E',
    'gray':   '#9E9E9E',
    'beige':  '#F5F5DC',
    'orange': '#FF9800',
    'maroon': '#800000',
  };
}
