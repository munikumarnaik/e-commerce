import 'package:freezed_annotation/freezed_annotation.dart';
import 'clothing_details.dart';
import 'food_details.dart';
import 'product_image_model.dart';
import 'product_variant_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Parses a value that may be a String or num into a double.
/// Handles backend returning "0.00" (String) instead of 0.0 (num).
double parseDoubleField(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@freezed
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String name,
    required String slug,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
}

@freezed
class ProductBrand with _$ProductBrand {
  const factory ProductBrand({
    required String id,
    required String name,
    String? logo,
  }) = _ProductBrand;

  factory ProductBrand.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String slug,
    String? sku,
    @JsonKey(name: 'product_type') required String productType,
    ProductCategory? category,
    ProductBrand? brand,
    String? description,
    @JsonKey(name: 'short_description') String? shortDescription,
    required String price,
    @JsonKey(name: 'compare_at_price') String? compareAtPrice,
    @JsonKey(name: 'discount_percentage') String? discountPercentage,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'track_inventory') @Default(true) bool trackInventory,
    String? thumbnail,
    @Default([]) List<ProductImage> images,
    @JsonKey(name: 'average_rating', fromJson: parseDoubleField) @Default(0.0) double averageRating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'has_variants') @Default(false) bool hasVariants,
    @JsonKey(name: 'variants_preview') @Default([]) List<ProductVariant> variantsPreview,
    @JsonKey(name: 'food_details') FoodDetails? foodDetails,
    @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
