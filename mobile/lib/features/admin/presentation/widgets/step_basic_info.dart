import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../product/presentation/providers/category_provider.dart';
import '../providers/create_product_provider.dart';
import 'admin_form_field.dart';

class StepBasicInfo extends ConsumerWidget {
  const StepBasicInfo({super.key});

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
            AppStrings.basicInfo,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Product Name
          AdminFormField(
            label: AppStrings.productName,
            initialValue: formState.name,
            onChanged: notifier.updateName,
            required: true,
            validator: (v) =>
                v == null || v.isEmpty ? AppStrings.fieldRequired : null,
          ),

          // Description
          AdminFormField(
            label: AppStrings.productDescription,
            initialValue: formState.description,
            onChanged: notifier.updateDescription,
            maxLines: 4,
            required: true,
            validator: (v) =>
                v == null || v.isEmpty ? AppStrings.fieldRequired : null,
          ),

          // Product Type Toggle
          Text(
            '${AppStrings.productType} *',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'FOOD',
                label: Text('Food'),
                icon: Icon(Icons.restaurant_rounded),
              ),
              ButtonSegment(
                value: 'CLOTHING',
                label: Text('Clothing'),
                icon: Icon(Icons.checkroom_rounded),
              ),
            ],
            selected: {formState.productType},
            onSelectionChanged: (value) =>
                notifier.updateProductType(value.first),
          ),
          const SizedBox(height: AppDimensions.md),

          // Category Dropdown
          _CategoryDropdown(
            selectedId: formState.categoryId,
            productType: formState.productType,
            onChanged: notifier.updateCategory,
          ),

          // Brand (optional)
          AdminFormField(
            label: AppStrings.brand,
            initialValue: formState.brand,
            onChanged: notifier.updateBrand,
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  final String? selectedId;
  final String productType;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    required this.selectedId,
    required this.productType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(
      categoriesProvider(productType == 'FOOD' ? 'FOOD' : 'CLOTHING'),
    );

    return categoriesAsync.when(
      data: (categories) {
        final validSelected =
            categories.any((c) => c.id == selectedId) ? selectedId : null;

        return AdminDropdownField<String>(
          label: AppStrings.category,
          value: validSelected,
          required: true,
          items: categories
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: onChanged,
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: AppDimensions.md),
        child: LinearProgressIndicator(),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: Text(
          'Failed to load categories',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
