import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/admin_product_repository.dart';
import '../../domain/models/create_product_request.dart';
import '../../domain/models/product_form_state.dart';
// VariantEntry is defined in product_form_state.dart

final createProductProvider =
    StateNotifierProvider.autoDispose<CreateProductNotifier, ProductFormState>(
  (ref) => CreateProductNotifier(ref.watch(adminProductRepositoryProvider)),
);

class CreateProductNotifier extends StateNotifier<ProductFormState> {
  final AdminProductRepository _repository;

  CreateProductNotifier(this._repository) : super(const ProductFormState());

  int get _maxStep => state.productType == 'CLOTHING' ? 4 : 3;

  // Step navigation
  void nextStep() {
    if (state.currentStep < _maxStep && state.validateCurrentStep()) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= _maxStep) {
      state = state.copyWith(currentStep: step);
    }
  }

  // Step 1: Basic Info
  void updateName(String value) => state = state.copyWith(name: value);
  void updateDescription(String value) => state = state.copyWith(description: value);
  void updateBrand(String? value) => state = state.copyWith(brand: value);
  void updateCategory(String? value) => state = state.copyWith(categoryId: value);
  void updateProductType(String value) => state = state.copyWith(productType: value);

  // Step 2: Pricing
  void updatePrice(String value) => state = state.copyWith(price: value);
  void updateCompareAtPrice(String? value) => state = state.copyWith(compareAtPrice: value);
  void updateStockQuantity(String value) => state = state.copyWith(stockQuantity: value);
  void updateSku(String? value) => state = state.copyWith(sku: value);

  // Step 3: Images
  void addImages(List<XFile> newImages) {
    state = state.copyWith(images: [...state.images, ...newImages]);
  }

  void removeImage(int index) {
    final updated = [...state.images];
    updated.removeAt(index);
    state = state.copyWith(images: updated);
  }

  // Step 4: Food Details
  void updateFoodType(String? value) => state = state.copyWith(foodType: value);
  void updateCuisineType(String? value) => state = state.copyWith(cuisineType: value);
  void updateSpiceLevel(int value) => state = state.copyWith(spiceLevel: value);
  void updateCalories(String? value) => state = state.copyWith(calories: value);
  void updateProtein(String? value) => state = state.copyWith(protein: value);
  void updateCarbs(String? value) => state = state.copyWith(carbs: value);
  void updateFat(String? value) => state = state.copyWith(fat: value);
  void updateServingSize(String? value) => state = state.copyWith(servingSize: value);
  void updatePreparationTime(String? value) => state = state.copyWith(preparationTime: value);
  void toggleGluten() => state = state.copyWith(containsGluten: !state.containsGluten);
  void toggleDairy() => state = state.copyWith(containsDairy: !state.containsDairy);
  void toggleNuts() => state = state.copyWith(containsNuts: !state.containsNuts);

  // Step 5: Variants (Clothing only)
  void addVariant(VariantEntry variant) {
    state = state.copyWith(variants: [...state.variants, variant]);
  }

  void removeVariant(int index) {
    final updated = [...state.variants];
    updated.removeAt(index);
    state = state.copyWith(variants: updated);
  }

  // Step 4: Clothing Details
  void updateClothingGender(String? value) => state = state.copyWith(clothingGender: value);
  void updateClothingType(String? value) => state = state.copyWith(clothingType: value);
  void updateMaterial(String? value) => state = state.copyWith(material: value);
  void updateFabric(String? value) => state = state.copyWith(fabric: value);
  void updateCareInstructions(String? value) => state = state.copyWith(careInstructions: value);
  void updateFitType(String? value) => state = state.copyWith(fitType: value);
  void updatePattern(String? value) => state = state.copyWith(pattern: value);
  void updateSeason(String? value) => state = state.copyWith(season: value);

  // Submit
  Future<void> submit() async {
    if (!state.validateCurrentStep()) return;

    state = state.copyWith(status: ProductFormStatus.submitting, errorMessage: null);

    try {
      // Phase 1: Create product (variants included in the same request — no separate calls)
      final request = CreateProductRequest(
        name: state.name,
        description: state.description,
        productType: state.productType,
        category: state.categoryId!,
        price: double.parse(state.price),
        compareAtPrice: state.compareAtPrice != null && state.compareAtPrice!.isNotEmpty
            ? double.tryParse(state.compareAtPrice!)
            : null,
        stockQuantity: int.parse(state.stockQuantity),
        sku: state.sku,
        brand: state.brand,
        foodDetails: state.buildFoodDetails(),
        clothingDetails: state.buildClothingDetails(),
        variants: state.variants.isNotEmpty
            ? state.variants.map((v) => v.toJson()).toList()
            : null,
      );

      final productData = await _repository.createProduct(request);
      final slug = productData['slug'] as String;

      // Phase 2: Upload images
      state = state.copyWith(status: ProductFormStatus.uploadingImages);

      String? firstImageUrl;
      for (final image in state.images) {
        final imageData = await _repository.uploadImage(slug, image);
        firstImageUrl ??= imageData['image_url'] as String?;
      }

      // Phase 3: Patch thumbnail with first image URL
      if (firstImageUrl != null) {
        await _repository.updateProduct(slug, {'thumbnail': firstImageUrl});
      }

      state = state.copyWith(
        status: ProductFormStatus.success,
        createdProductSlug: slug,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const ProductFormState();
  }
}
