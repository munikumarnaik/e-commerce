import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/product_filter.dart';

class ClothingFilterContent extends StatefulWidget {
  final ProductFilter filter;
  final ValueChanged<ProductFilter> onFilterChanged;

  const ClothingFilterContent({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  State<ClothingFilterContent> createState() => _ClothingFilterContentState();
}

class _ClothingFilterContentState extends State<ClothingFilterContent> {
  late ProductFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gender
        _SectionTitle(title: AppStrings.gender),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            for (final gender in ['Men', 'Women', 'Unisex', 'Kids'])
              _FilterChip(
                label: gender,
                isSelected:
                    _filter.gender == gender.toUpperCase(),
                onTap: () => _setGender(gender.toUpperCase()),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),

        // Size
        _SectionTitle(title: AppStrings.sizeLabel),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            for (final size in ['XS', 'S', 'M', 'L', 'XL', 'XXL'])
              _SizeChip(
                label: size,
                isSelected: _filter.size == size,
                onTap: () => _setSize(size),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),

        // Color Swatches
        _SectionTitle(title: AppStrings.colorLabel),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            for (final entry in _colorOptions.entries)
              _ColorSwatch(
                color: entry.value,
                label: entry.key,
                isSelected: _filter.color == entry.key,
                onTap: () => _setColor(entry.key),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),

        // Price Range
        _SectionTitle(title: AppStrings.priceRange),
        const SizedBox(height: AppDimensions.sm),
        RangeSlider(
          values: RangeValues(
            _filter.minPrice ?? 0,
            _filter.maxPrice ?? 10000,
          ),
          min: 0,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            '₹${(_filter.minPrice ?? 0).toInt()}',
            '₹${(_filter.maxPrice ?? 10000).toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _filter.minPrice = values.start == 0 ? null : values.start;
              _filter.maxPrice = values.end == 10000 ? null : values.end;
            });
            widget.onFilterChanged(_filter);
          },
        ),
        const SizedBox(height: AppDimensions.lg),

        // Sort By
        _SectionTitle(title: AppStrings.sortBy),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            _FilterChip(
              label: 'Newest',
              isSelected: _filter.ordering == '-created_at',
              onTap: () => _setOrdering('-created_at'),
            ),
            _FilterChip(
              label: 'Price: Low to High',
              isSelected: _filter.ordering == 'price',
              onTap: () => _setOrdering('price'),
            ),
            _FilterChip(
              label: 'Price: High to Low',
              isSelected: _filter.ordering == '-price',
              onTap: () => _setOrdering('-price'),
            ),
            _FilterChip(
              label: 'Popular',
              isSelected: _filter.ordering == '-average_rating',
              onTap: () => _setOrdering('-average_rating'),
            ),
          ],
        ),
      ],
    );
  }

  static const _colorOptions = {
    'Black': Color(0xFF000000),
    'White': Color(0xFFFFFFFF),
    'Red': Color(0xFFE53935),
    'Blue': Color(0xFF1E88E5),
    'Green': Color(0xFF43A047),
    'Yellow': Color(0xFFFDD835),
    'Pink': Color(0xFFE91E63),
    'Navy': Color(0xFF1A237E),
    'Grey': Color(0xFF9E9E9E),
    'Brown': Color(0xFF795548),
  };

  void _setGender(String gender) {
    setState(() {
      _filter.gender = _filter.gender == gender ? null : gender;
    });
    widget.onFilterChanged(_filter);
  }

  void _setSize(String size) {
    setState(() {
      _filter.size = _filter.size == size ? null : size;
    });
    widget.onFilterChanged(_filter);
  }

  void _setColor(String color) {
    setState(() {
      _filter.color = _filter.color == color ? null : color;
    });
    widget.onFilterChanged(_filter);
  }

  void _setOrdering(String ordering) {
    setState(() {
      _filter.ordering = _filter.ordering == ordering ? null : ordering;
    });
    widget.onFilterChanged(_filter);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
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
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
