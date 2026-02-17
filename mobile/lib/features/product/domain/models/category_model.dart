import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'product_count') @Default(0) int productCount,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'category_type') String? categoryType,
    String? parent,
    String? image,
    String? icon,
    String? description,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'product_count') @Default(0) int productCount,
    @Default([]) List<SubCategory> subcategories,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
