import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/create_product_provider.dart';
import 'admin_form_field.dart';

// Shared formatters
final _decimalFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'));
final _integerFormatter = FilteringTextInputFormatter.digitsOnly;
final _lettersOnlyFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
final _lettersAndBasicFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,/\-]'));

class StepTypeDetails extends ConsumerWidget {
  const StepTypeDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createProductProvider);

    if (formState.productType == 'FOOD') {
      return const _FoodDetailsForm();
    }
    return const _ClothingDetailsForm();
  }
}

class _FoodDetailsForm extends ConsumerWidget {
  const _FoodDetailsForm();

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
            'Food Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Food Type
          AdminDropdownField<String>(
            label: AppStrings.foodType,
            value: formState.foodType,
            required: true,
            items: const [
              DropdownMenuItem(value: 'VEG', child: Text('Vegetarian')),
              DropdownMenuItem(value: 'NON_VEG', child: Text('Non-Vegetarian')),
              DropdownMenuItem(value: 'VEGAN', child: Text('Vegan')),
              DropdownMenuItem(value: 'EGGETARIAN', child: Text('Eggetarian')),
            ],
            onChanged: notifier.updateFoodType,
          ),

          // Cuisine Type — letters and spaces only
          AdminFormField(
            label: AppStrings.cuisineType,
            hint: 'e.g. Indian, Italian, Chinese',
            initialValue: formState.cuisineType,
            onChanged: notifier.updateCuisineType,
            inputFormatters: [_lettersOnlyFormatter],
          ),

          // Spice Level
          Text(
            AppStrings.spiceLevel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: formState.spiceLevel.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            label: '${formState.spiceLevel}',
            onChanged: (v) => notifier.updateSpiceLevel(v.toInt()),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Nutrition
          Text(
            AppStrings.nutritionInfo,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          Row(
            children: [
              Expanded(
                child: AdminFormField(
                  label: AppStrings.calories,
                  hint: 'e.g. 250',
                  initialValue: formState.calories,
                  onChanged: notifier.updateCalories,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_integerFormatter],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: AdminFormField(
                  label: AppStrings.protein,
                  hint: 'e.g. 12.5',
                  initialValue: formState.protein,
                  onChanged: notifier.updateProtein,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [_decimalFormatter],
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: AdminFormField(
                  label: AppStrings.carbs,
                  hint: 'e.g. 30.0',
                  initialValue: formState.carbs,
                  onChanged: notifier.updateCarbs,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [_decimalFormatter],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: AdminFormField(
                  label: AppStrings.fat,
                  hint: 'e.g. 8.0',
                  initialValue: formState.fat,
                  onChanged: notifier.updateFat,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [_decimalFormatter],
                ),
              ),
            ],
          ),

          // Serving size — letters, numbers, g/ml/plate allowed
          AdminFormField(
            label: AppStrings.servingSize,
            hint: 'e.g. 250g, 1 plate',
            initialValue: formState.servingSize,
            onChanged: notifier.updateServingSize,
            inputFormatters: [_lettersAndBasicFormatter],
          ),

          // Preparation time — integers only (minutes)
          AdminFormField(
            label: AppStrings.preparationTime,
            hint: 'Minutes (e.g. 30)',
            initialValue: formState.preparationTime,
            onChanged: notifier.updatePreparationTime,
            keyboardType: TextInputType.number,
            inputFormatters: [_integerFormatter],
          ),

          // Allergens
          Text(
            AppStrings.allergens,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          SwitchListTile(
            title: const Text('Contains Gluten'),
            value: formState.containsGluten,
            onChanged: (_) => notifier.toggleGluten(),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Contains Dairy'),
            value: formState.containsDairy,
            onChanged: (_) => notifier.toggleDairy(),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Contains Nuts'),
            value: formState.containsNuts,
            onChanged: (_) => notifier.toggleNuts(),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _ClothingDetailsForm extends ConsumerWidget {
  const _ClothingDetailsForm();

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
            'Clothing Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Gender
          AdminDropdownField<String>(
            label: AppStrings.clothingGender,
            value: formState.clothingGender,
            required: true,
            items: const [
              DropdownMenuItem(value: 'MEN', child: Text('Men')),
              DropdownMenuItem(value: 'WOMEN', child: Text('Women')),
              DropdownMenuItem(value: 'UNISEX', child: Text('Unisex')),
              DropdownMenuItem(value: 'KIDS', child: Text('Kids')),
            ],
            onChanged: notifier.updateClothingGender,
          ),

          // Clothing Type
          AdminDropdownField<String>(
            label: AppStrings.clothingType,
            value: formState.clothingType,
            required: true,
            items: const [
              DropdownMenuItem(value: 'TOPWEAR', child: Text('Topwear')),
              DropdownMenuItem(value: 'BOTTOMWEAR', child: Text('Bottomwear')),
              DropdownMenuItem(value: 'FOOTWEAR', child: Text('Footwear')),
              DropdownMenuItem(
                  value: 'ACCESSORIES', child: Text('Accessories')),
              DropdownMenuItem(value: 'INNERWEAR', child: Text('Innerwear')),
              DropdownMenuItem(value: 'ETHNIC', child: Text('Ethnic')),
              DropdownMenuItem(value: 'SPORTSWEAR', child: Text('Sportswear')),
            ],
            onChanged: notifier.updateClothingType,
          ),

          // Material — letters and spaces only
          AdminFormField(
            label: AppStrings.clothingMaterial,
            hint: 'e.g. Cotton, Polyester, Silk',
            initialValue: formState.material,
            onChanged: notifier.updateMaterial,
            required: true,
            inputFormatters: [_lettersOnlyFormatter],
            validator: (v) =>
                v == null || v.isEmpty ? AppStrings.fieldRequired : null,
          ),

          // Fabric — letters and spaces only
          AdminFormField(
            label: AppStrings.fabric,
            hint: 'e.g. Denim, Chiffon, Knit',
            initialValue: formState.fabric,
            onChanged: notifier.updateFabric,
            inputFormatters: [_lettersOnlyFormatter],
          ),

          // Care Instructions — letters, spaces, commas allowed
          AdminFormField(
            label: AppStrings.careInstructions,
            hint: 'e.g. Machine wash cold',
            initialValue: formState.careInstructions,
            onChanged: notifier.updateCareInstructions,
            maxLines: 2,
            inputFormatters: [_lettersAndBasicFormatter],
          ),

          // Fit Type
          AdminDropdownField<String>(
            label: AppStrings.fitType,
            value: formState.fitType,
            items: const [
              DropdownMenuItem(value: 'SLIM', child: Text('Slim Fit')),
              DropdownMenuItem(value: 'REGULAR', child: Text('Regular Fit')),
              DropdownMenuItem(value: 'LOOSE', child: Text('Loose Fit')),
              DropdownMenuItem(value: 'OVERSIZED', child: Text('Oversized')),
            ],
            onChanged: notifier.updateFitType,
          ),

          // Pattern — letters only
          AdminFormField(
            label: AppStrings.pattern,
            hint: 'e.g. Solid, Striped, Printed',
            initialValue: formState.pattern,
            onChanged: notifier.updatePattern,
            inputFormatters: [_lettersOnlyFormatter],
          ),

          // Season
          AdminDropdownField<String>(
            label: AppStrings.season,
            value: formState.season,
            items: const [
              DropdownMenuItem(value: 'SUMMER', child: Text('Summer')),
              DropdownMenuItem(value: 'WINTER', child: Text('Winter')),
              DropdownMenuItem(value: 'MONSOON', child: Text('Monsoon')),
              DropdownMenuItem(
                  value: 'ALL_SEASON', child: Text('All Season')),
            ],
            onChanged: notifier.updateSeason,
          ),
        ],
      ),
    );
  }
}
