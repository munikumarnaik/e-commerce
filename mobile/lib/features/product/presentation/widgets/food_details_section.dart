import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/food_details.dart';

class FoodDetailsSection extends StatelessWidget {
  final FoodDetails details;

  const FoodDetailsSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prep time & Serving size row
        if (details.preparationTime != null || details.servingSize != null)
          Row(
            children: [
              if (details.preparationTime != null)
                _InfoChip(
                  icon: Icons.timer_outlined,
                  label: '${details.preparationTime} min',
                ),
              if (details.preparationTime != null &&
                  details.servingSize != null)
                const SizedBox(width: AppDimensions.md),
              if (details.servingSize != null)
                _InfoChip(
                  icon: Icons.restaurant_outlined,
                  label: details.servingSize!,
                ),
            ],
          ),

        if (details.preparationTime != null || details.servingSize != null)
          const SizedBox(height: AppDimensions.lg),

        // Nutrition Info
        if (_hasNutritionData) ...[
          Text(
            AppStrings.nutritionInfo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              if (details.calories != null)
                _NutritionCard(
                  label: 'Calories',
                  value: '${details.calories}',
                  unit: 'kcal',
                  color: const Color(0xFFFF6B35),
                ),
              if (details.protein != null)
                _NutritionCard(
                  label: 'Protein',
                  value: '${details.protein}',
                  unit: 'g',
                  color: const Color(0xFF2EC4B6),
                ),
              if (details.carbs != null)
                _NutritionCard(
                  label: 'Carbs',
                  value: '${details.carbs}',
                  unit: 'g',
                  color: const Color(0xFFFFBE0B),
                ),
              if (details.fat != null)
                _NutritionCard(
                  label: 'Fat',
                  value: '${details.fat}',
                  unit: 'g',
                  color: const Color(0xFFE94560),
                ),
            ].expand((w) => [Expanded(child: w)]).toList(),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],

        // Allergens
        if (_allergenLabels.isNotEmpty) ...[
          Text(
            AppStrings.allergens,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: _allergenLabels.map((label) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm + 2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        // Cuisine & Spice
        if (details.cuisineType != null || details.spiceLevel > 0) ...[
          const SizedBox(height: AppDimensions.lg),
          if (details.cuisineType != null)
            _DetailRow(label: 'Cuisine', value: details.cuisineType!),
          if (details.spiceLevel > 0)
            _DetailRow(
              label: 'Spice Level',
              value: _spiceLevelLabel(details.spiceLevel),
              trailing: _SpiceIndicator(level: details.spiceLevel),
            ),
        ],
      ],
    );
  }

  bool get _hasNutritionData =>
      details.calories != null ||
      details.protein != null ||
      details.carbs != null ||
      details.fat != null;

  List<String> get _allergenLabels {
    final labels = <String>[];
    if (details.containsGluten) labels.add('Gluten');
    if (details.containsDairy) labels.add('Dairy');
    if (details.containsNuts) labels.add('Nuts');
    return labels;
  }

  String _spiceLevelLabel(int level) {
    return switch (level) {
      1 => 'Mild',
      2 => 'Medium',
      3 => 'Hot',
      4 => 'Extra Hot',
      _ => 'None',
    };
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm + 2,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutritionCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm + 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _DetailRow({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimensions.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _SpiceIndicator extends StatelessWidget {
  final int level;

  const _SpiceIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    final count = level.clamp(0, 4);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (i) => Icon(
          Icons.local_fire_department_rounded,
          size: 14,
          color: i < count
              ? const Color(0xFFE94560)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
