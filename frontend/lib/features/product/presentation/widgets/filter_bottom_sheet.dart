import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/product_filter.dart';
import 'clothing_filter_content.dart';
import 'food_filter_content.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilter currentFilter;
  final bool isFood;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.isFood,
  });

  static Future<ProductFilter?> show(
    BuildContext context, {
    required ProductFilter currentFilter,
    required bool isFood,
  }) {
    return showModalBottomSheet<ProductFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (_) => FilterBottomSheet(
        currentFilter: currentFilter,
        isFood: isFood,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ProductFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle + header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.md,
                AppDimensions.md,
                0,
              ),
              child: Column(
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.filters,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            // Preserve categoryType
                            _filter.categoryType =
                                widget.currentFilter.categoryType;
                          });
                        },
                        child: Text(AppStrings.clearAll),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Filter content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: widget.isFood
                    ? FoodFilterContent(
                        filter: _filter,
                        onFilterChanged: (f) => setState(() => _filter = f),
                      )
                    : ClothingFilterContent(
                        filter: _filter,
                        onFilterChanged: (f) => setState(() => _filter = f),
                      ),
              ),
            ),

            // Apply button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.sm,
                AppDimensions.lg,
                AppDimensions.lg + MediaQuery.viewPaddingOf(context).bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _filter),
                  child: Text(AppStrings.applyFilters),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
