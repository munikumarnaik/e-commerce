import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variant_model.freezed.dart';
part 'product_variant_model.g.dart';

@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    String? sku,
    @Default('') String size,
    @Default('') String color,
    @JsonKey(name: 'color_hex') String? colorHex,
    String? price,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
}
