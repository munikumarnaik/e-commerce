import 'package:image_picker/image_picker.dart';

enum ProductFormStatus { idle, submitting, uploadingImages, success, error }

class VariantEntry {
  final String size;
  final String? color;
  final String? colorHex;
  final int stockQuantity;
  final double? price;
  final String? sku;

  const VariantEntry({
    required this.size,
    this.color,
    this.colorHex,
    required this.stockQuantity,
    this.price,
    this.sku,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'size': size,
      'stock_quantity': stockQuantity,
    };
    if (color != null && color!.isNotEmpty) map['color'] = color;
    if (colorHex != null && colorHex!.isNotEmpty) map['color_hex'] = colorHex;
    if (price != null) map['price'] = price;
    if (sku != null && sku!.isNotEmpty) map['sku'] = sku;
    return map;
  }
}

class ProductFormState {
  // Step tracking
  final int currentStep;
  final ProductFormStatus status;
  final String? errorMessage;
  final String? createdProductSlug;

  // Step 1: Basic Info
  final String name;
  final String description;
  final String? brand;
  final String? categoryId;
  final String productType; // FOOD or CLOTHING

  // Step 2: Pricing
  final String price;
  final String? compareAtPrice;
  final String stockQuantity;
  final String? sku;

  // Step 3: Images
  final List<XFile> images;

  // Step 4: Food Details
  final String? foodType;
  final String? cuisineType;
  final int spiceLevel;
  final String? calories;
  final String? protein;
  final String? carbs;
  final String? fat;
  final String? servingSize;
  final String? preparationTime;
  final bool containsGluten;
  final bool containsDairy;
  final bool containsNuts;

  // Step 4: Clothing Details
  final String? clothingGender;
  final String? clothingType;
  final String? material;
  final String? fabric;
  final String? careInstructions;
  final String? fitType;
  final String? pattern;
  final String? season;

  // Step 5: Variants (Clothing only)
  final List<VariantEntry> variants;

  const ProductFormState({
    this.currentStep = 0,
    this.status = ProductFormStatus.idle,
    this.errorMessage,
    this.createdProductSlug,
    this.name = '',
    this.description = '',
    this.brand,
    this.categoryId,
    this.productType = 'FOOD',
    this.price = '',
    this.compareAtPrice,
    this.stockQuantity = '',
    this.sku,
    this.images = const [],
    this.foodType,
    this.cuisineType,
    this.spiceLevel = 0,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.servingSize,
    this.preparationTime,
    this.containsGluten = false,
    this.containsDairy = false,
    this.containsNuts = false,
    this.clothingGender,
    this.clothingType,
    this.material,
    this.fabric,
    this.careInstructions,
    this.fitType,
    this.pattern,
    this.season,
    this.variants = const [],
  });

  ProductFormState copyWith({
    int? currentStep,
    ProductFormStatus? status,
    String? errorMessage,
    String? createdProductSlug,
    String? name,
    String? description,
    String? brand,
    String? categoryId,
    String? productType,
    String? price,
    String? compareAtPrice,
    String? stockQuantity,
    String? sku,
    List<XFile>? images,
    String? foodType,
    String? cuisineType,
    int? spiceLevel,
    String? calories,
    String? protein,
    String? carbs,
    String? fat,
    String? servingSize,
    String? preparationTime,
    bool? containsGluten,
    bool? containsDairy,
    bool? containsNuts,
    String? clothingGender,
    String? clothingType,
    String? material,
    String? fabric,
    String? careInstructions,
    String? fitType,
    String? pattern,
    String? season,
    List<VariantEntry>? variants,
  }) {
    return ProductFormState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdProductSlug: createdProductSlug ?? this.createdProductSlug,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      productType: productType ?? this.productType,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      images: images ?? this.images,
      foodType: foodType ?? this.foodType,
      cuisineType: cuisineType ?? this.cuisineType,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      servingSize: servingSize ?? this.servingSize,
      preparationTime: preparationTime ?? this.preparationTime,
      containsGluten: containsGluten ?? this.containsGluten,
      containsDairy: containsDairy ?? this.containsDairy,
      containsNuts: containsNuts ?? this.containsNuts,
      clothingGender: clothingGender ?? this.clothingGender,
      clothingType: clothingType ?? this.clothingType,
      material: material ?? this.material,
      fabric: fabric ?? this.fabric,
      careInstructions: careInstructions ?? this.careInstructions,
      fitType: fitType ?? this.fitType,
      pattern: pattern ?? this.pattern,
      season: season ?? this.season,
      variants: variants ?? this.variants,
    );
  }

  bool validateStep1() => name.isNotEmpty && description.isNotEmpty && categoryId != null;

  bool validateStep2() {
    final p = double.tryParse(price);
    final q = int.tryParse(stockQuantity);
    return p != null && p > 0 && q != null && q >= 0;
  }

  bool validateStep3() => images.isNotEmpty;

  bool validateStep4() {
    if (productType == 'FOOD') {
      return foodType != null && foodType!.isNotEmpty;
    } else {
      return clothingGender != null &&
          clothingType != null &&
          material != null &&
          clothingGender!.isNotEmpty &&
          clothingType!.isNotEmpty &&
          material!.isNotEmpty;
    }
  }

  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return validateStep1();
      case 1:
        return validateStep2();
      case 2:
        return validateStep3();
      case 3:
        return validateStep4();
      case 4:
        return variants.isNotEmpty; // at least one variant required for clothing
      default:
        return false;
    }
  }

  Map<String, dynamic>? buildFoodDetails() {
    if (productType != 'FOOD') return null;
    final map = <String, dynamic>{
      'food_type': foodType,
    };
    if (cuisineType != null && cuisineType!.isNotEmpty) map['cuisine_type'] = cuisineType;
    if (spiceLevel > 0) map['spice_level'] = spiceLevel;
    if (calories != null && calories!.isNotEmpty) map['calories'] = int.tryParse(calories!) ?? 0;
    if (protein != null && protein!.isNotEmpty) map['protein'] = double.tryParse(protein!) ?? 0;
    if (carbs != null && carbs!.isNotEmpty) map['carbs'] = double.tryParse(carbs!) ?? 0;
    if (fat != null && fat!.isNotEmpty) map['fat'] = double.tryParse(fat!) ?? 0;
    if (servingSize != null && servingSize!.isNotEmpty) map['serving_size'] = servingSize;
    if (preparationTime != null && preparationTime!.isNotEmpty) {
      map['preparation_time'] = int.tryParse(preparationTime!) ?? 0;
    }
    map['contains_gluten'] = containsGluten;
    map['contains_dairy'] = containsDairy;
    map['contains_nuts'] = containsNuts;
    return map;
  }

  Map<String, dynamic>? buildClothingDetails() {
    if (productType != 'CLOTHING') return null;
    final map = <String, dynamic>{
      'gender': clothingGender,
      'clothing_type': clothingType,
      'material': material,
    };
    if (fabric != null && fabric!.isNotEmpty) map['fabric'] = fabric;
    if (careInstructions != null && careInstructions!.isNotEmpty) {
      map['care_instructions'] = careInstructions;
    }
    if (fitType != null && fitType!.isNotEmpty) map['fit_type'] = fitType;
    if (pattern != null && pattern!.isNotEmpty) map['pattern'] = pattern;
    if (season != null && season!.isNotEmpty) map['season'] = season;
    return map;
  }
}
