class ProductFilter {
  String? search;
  String? categoryId;
  String? categoryType;
  String? brandId;
  double? minPrice;
  double? maxPrice;
  bool? isFeatured;
  String? ordering;
  int? minRating;

  // Food-specific
  String? foodType;
  String? cuisineType;

  // Clothing-specific
  String? gender;
  String? size;
  String? color;
  String? material;
  String? clothingType;

  ProductFilter({
    this.search,
    this.categoryId,
    this.categoryType,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.isFeatured,
    this.ordering,
    this.minRating,
    this.foodType,
    this.cuisineType,
    this.gender,
    this.size,
    this.color,
    this.material,
    this.clothingType,
  });

  ProductFilter copyWith({
    String? search,
    String? categoryId,
    String? categoryType,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    bool? isFeatured,
    String? ordering,
    int? minRating,
    String? foodType,
    String? cuisineType,
    String? gender,
    String? size,
    String? color,
    String? material,
    String? clothingType,
  }) {
    return ProductFilter(
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      categoryType: categoryType ?? this.categoryType,
      brandId: brandId ?? this.brandId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      isFeatured: isFeatured ?? this.isFeatured,
      ordering: ordering ?? this.ordering,
      minRating: minRating ?? this.minRating,
      foodType: foodType ?? this.foodType,
      cuisineType: cuisineType ?? this.cuisineType,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      color: color ?? this.color,
      material: material ?? this.material,
      clothingType: clothingType ?? this.clothingType,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (categoryId != null) params['category'] = categoryId;
    if (categoryType != null) params['category_type'] = categoryType;
    if (brandId != null) params['brand'] = brandId;
    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (isFeatured != null) params['is_featured'] = isFeatured.toString();
    if (ordering != null) params['ordering'] = ordering;
    if (minRating != null) params['min_rating'] = minRating.toString();
    if (foodType != null) params['food_type'] = foodType;
    if (cuisineType != null) params['cuisine_type'] = cuisineType;
    if (gender != null) params['gender'] = gender;
    if (size != null) params['size'] = size;
    if (color != null) params['color'] = color;
    if (material != null) params['material'] = material;
    if (clothingType != null) params['clothing_type'] = clothingType;
    return params;
  }

  void clear() {
    search = null;
    categoryId = null;
    brandId = null;
    minPrice = null;
    maxPrice = null;
    isFeatured = null;
    ordering = null;
    minRating = null;
    foodType = null;
    cuisineType = null;
    gender = null;
    size = null;
    color = null;
    material = null;
    clothingType = null;
  }

  bool get hasActiveFilters =>
      foodType != null ||
      cuisineType != null ||
      gender != null ||
      size != null ||
      color != null ||
      material != null ||
      clothingType != null ||
      minPrice != null ||
      maxPrice != null ||
      brandId != null ||
      minRating != null;
}
