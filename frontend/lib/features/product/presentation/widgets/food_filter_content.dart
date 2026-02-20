import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/product_filter.dart';

class FoodFilterContent extends StatefulWidget {
  final ProductFilter filter;
  final ValueChanged<ProductFilter> onFilterChanged;

  const FoodFilterContent({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  State<FoodFilterContent> createState() => _FoodFilterContentState();
}

class _FoodFilterContentState extends State<FoodFilterContent> {
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
        // Diet Type
        _SectionTitle(title: AppStrings.dietType),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            _FilterChip(
              label: 'Veg',
              isSelected: _filter.foodType == 'VEG',
              onTap: () => _setFoodType('VEG'),
            ),
            _FilterChip(
              label: 'Non-Veg',
              isSelected: _filter.foodType == 'NON_VEG',
              onTap: () => _setFoodType('NON_VEG'),
            ),
            _FilterChip(
              label: 'Vegan',
              isSelected: _filter.foodType == 'VEGAN',
              onTap: () => _setFoodType('VEGAN'),
            ),
            _FilterChip(
              label: 'Egg',
              isSelected: _filter.foodType == 'EGG',
              onTap: () => _setFoodType('EGG'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),

        // Cuisine
        _SectionTitle(title: AppStrings.cuisine),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            for (final cuisine in [
              'Indian',
              'Chinese',
              'Italian',
              'Mexican',
              'Japanese',
              'Thai',
              'Continental',
            ])
              _FilterChip(
                label: cuisine,
                isSelected: _filter.cuisineType == cuisine.toUpperCase(),
                onTap: () => _setCuisine(cuisine.toUpperCase()),
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
            _filter.maxPrice ?? 5000,
          ),
          min: 0,
          max: 5000,
          divisions: 50,
          labels: RangeLabels(
            '₹${(_filter.minPrice ?? 0).toInt()}',
            '₹${(_filter.maxPrice ?? 5000).toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _filter.minPrice = values.start == 0 ? null : values.start;
              _filter.maxPrice = values.end == 5000 ? null : values.end;
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
              label: 'Rating',
              isSelected: _filter.ordering == '-average_rating',
              onTap: () => _setOrdering('-average_rating'),
            ),
          ],
        ),
      ],
    );
  }

  void _setFoodType(String type) {
    setState(() {
      _filter.foodType = _filter.foodType == type ? null : type;
    });
    widget.onFilterChanged(_filter);
  }

  void _setCuisine(String cuisine) {
    setState(() {
      _filter.cuisineType = _filter.cuisineType == cuisine ? null : cuisine;
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
