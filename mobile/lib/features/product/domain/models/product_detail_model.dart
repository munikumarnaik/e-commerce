import 'package:freezed_annotation/freezed_annotation.dart';
import 'clothing_details.dart';
import 'food_details.dart';
import 'product_image_model.dart';
import 'product_model.dart';

part 'product_detail_model.freezed.dart';
part 'product_detail_model.g.dart';

@freezed
class ProductVendor with _$ProductVendor {
  const factory ProductVendor({
    required String id,
    required String name,
    @JsonKey(name: 'profile_image') String? profileImage,
  }) = _ProductVendor;

  factory ProductVendor.fromJson(Map<String, dynamic> json) =>
      _$ProductVendorFromJson(json);
}

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String id,
    required String name,
    required String slug,
    String? sku,
    @JsonKey(name: 'product_type') required String productType,
    ProductCategory? category,
    ProductBrand? brand,
    ProductVendor? vendor,
    String? description,
    @JsonKey(name: 'short_description') String? shortDescription,
    required String price,
    @JsonKey(name: 'compare_at_price') String? compareAtPrice,
    @JsonKey(name: 'discount_percentage') String? discountPercentage,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'track_inventory') @Default(true) bool trackInventory,
    String? thumbnail,
    @Default([]) List<ProductImage> images,
    @JsonKey(name: 'average_rating') @Default(0.0) double averageRating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'has_variants') @Default(false) bool hasVariants,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'food_details') FoodDetails? foodDetails,
    @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
}
