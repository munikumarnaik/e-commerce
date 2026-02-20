import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../product/presentation/providers/category_provider.dart';
import '../../../data/repositories/admin_product_repository.dart';
import '../../providers/create_product_provider.dart';
import 'admin_form_field.dart';

class StepBasicInfo extends ConsumerWidget {
  const StepBasicInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createProductProvider);
    final notifier = ref.read(createProductProvider.notifier);
    final theme = Theme.of(context);
    final isFood = formState.productType == 'FOOD';

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

          // Category dropdown + "Add Category" button
          _CategorySection(
            selectedId: formState.categoryId,
            productType: formState.productType,
            onChanged: notifier.updateCategory,
          ),

          // Brand — only shown for CLOTHING
          if (!isFood)
            AdminFormField(
              label: AppStrings.brand,
              hint: 'Brand name (optional)',
              initialValue: formState.brand,
              onChanged: notifier.updateBrand,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s\-&.]')),
              ],
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Category section: dropdown + "Add Category" button
// ──────────────────────────────────────────────
class _CategorySection extends ConsumerWidget {
  final String? selectedId;
  final String productType;
  final ValueChanged<String?> onChanged;

  const _CategorySection({
    required this.selectedId,
    required this.productType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _CategoryDropdown(
            selectedId: selectedId,
            productType: productType,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: AppDimensions.md),
          child: Tooltip(
            message: 'Add new category',
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                minimumSize: const Size(48, 52),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
              onPressed: () async {
                final created = await showDialog<bool>(
                  context: context,
                  builder: (_) => _AddCategoryDialog(productType: productType),
                );
                if (created == true) {
                  // Refresh category dropdown with newly created category
                  ref.invalidate(categoriesProvider(productType));
                }
              },
              child: const Icon(Icons.add_rounded),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Category dropdown
// ──────────────────────────────────────────────
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

// ──────────────────────────────────────────────
// Add Category dialog
// ──────────────────────────────────────────────
class _AddCategoryDialog extends ConsumerStatefulWidget {
  final String productType;

  const _AddCategoryDialog({required this.productType});

  @override
  ConsumerState<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<_AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = ref.read(adminProductRepositoryProvider);
      await repository.createCategory(
        name: _nameController.text.trim(),
        categoryType: widget.productType,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to create category. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = widget.productType == 'FOOD' ? 'Food' : 'Clothing';

    return AlertDialog(
      title: Text('Add $label Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              // Only letters and spaces
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Category Name *',
                hintText: 'e.g. Snacks, Tops, Footwear',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            if (_error != null) ...[
              const SizedBox(height: AppDimensions.sm),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
