import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/clothing_details.dart';

class ClothingDetailsSection extends StatelessWidget {
  final ClothingDetails details;

  const ClothingDetailsSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick info chips
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            if (details.gender != null)
              _InfoChip(
                icon: Icons.person_outline_rounded,
                label: _formatEnum(details.gender!),
              ),
            if (details.fitType != null)
              _InfoChip(
                icon: Icons.straighten_rounded,
                label: _formatEnum(details.fitType!),
              ),
            if (details.season != null)
              _InfoChip(
                icon: Icons.wb_sunny_outlined,
                label: _formatEnum(details.season!),
              ),
            if (details.pattern != null)
              _InfoChip(
                icon: Icons.grid_on_rounded,
                label: _formatEnum(details.pattern!),
              ),
          ],
        ),

        const SizedBox(height: AppDimensions.lg),

        // Material & Fabric
        if (details.material != null || details.fabric != null) ...[
          Text(
            AppStrings.materialInfo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.material != null)
                  _DetailRow(label: 'Material', value: details.material!),
                if (details.fabric != null)
                  _DetailRow(label: 'Fabric', value: details.fabric!),
                if (details.clothingType != null)
                  _DetailRow(
                    label: 'Type',
                    value: _formatEnum(details.clothingType!),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],

        // Care Instructions
        if (details.careInstructions != null) ...[
          Text(
            AppStrings.careInstructions,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.dry_cleaning_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    details.careInstructions!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatEnum(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
