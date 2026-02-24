class CreateProductRequest {
  final String name;
  final String description;
  final String productType;
  final String category;
  final double price;
  final double? compareAtPrice;
  final int stockQuantity;
  final String? sku;
  final String? brand;
  final Map<String, dynamic>? foodDetails;
  final Map<String, dynamic>? clothingDetails;
  final List<Map<String, dynamic>>? variants;

  const CreateProductRequest({
    required this.name,
    required this.description,
    required this.productType,
    required this.category,
    required this.price,
    this.compareAtPrice,
    required this.stockQuantity,
    this.sku,
    this.brand,
    this.foodDetails,
    this.clothingDetails,
    this.variants,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'product_type': productType,
      'category': category,
      'price': price.toStringAsFixed(2),
      'stock_quantity': stockQuantity,
    };

    if (compareAtPrice != null) {
      map['compare_at_price'] = compareAtPrice!.toStringAsFixed(2);
    }
    if (sku != null && sku!.isNotEmpty) map['sku'] = sku;
    if (brand != null && brand!.isNotEmpty) map['brand'] = brand;
    if (foodDetails != null) map['food_details'] = foodDetails;
    if (clothingDetails != null) map['clothing_details'] = clothingDetails;
    if (variants != null && variants!.isNotEmpty) map['variants'] = variants;

    return map;
  }
}
