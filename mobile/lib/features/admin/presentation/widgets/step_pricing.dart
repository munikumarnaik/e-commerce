import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/create_product_provider.dart';
import 'admin_form_field.dart';

class StepPricing extends ConsumerWidget {
  const StepPricing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createProductProvider);
    final notifier = ref.read(createProductProvider.notifier);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.pricing,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Price
          AdminFormField(
            label: AppStrings.price,
            initialValue: formState.price,
            onChanged: notifier.updatePrice,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            required: true,
            validator: (v) {
              if (v == null || v.isEmpty) return AppStrings.fieldRequired;
              if (double.tryParse(v) == null) return AppStrings.invalidPrice;
              return null;
            },
          ),

          // Compare at Price
          AdminFormField(
            label: AppStrings.compareAtPrice,
            hint: 'Original price before discount',
            initialValue: formState.compareAtPrice,
            onChanged: notifier.updateCompareAtPrice,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),

          // Stock Quantity
          AdminFormField(
            label: AppStrings.stockQuantity,
            initialValue: formState.stockQuantity,
            onChanged: notifier.updateStockQuantity,
            keyboardType: TextInputType.number,
            required: true,
            validator: (v) {
              if (v == null || v.isEmpty) return AppStrings.fieldRequired;
              if (int.tryParse(v) == null) return AppStrings.invalidQuantity;
              return null;
            },
          ),

          // SKU
          AdminFormField(
            label: AppStrings.sku,
            hint: 'Stock Keeping Unit (optional)',
            initialValue: formState.sku,
            onChanged: notifier.updateSku,
          ),
        ],
      ),
    );
  }
}
