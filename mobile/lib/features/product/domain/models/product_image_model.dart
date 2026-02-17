import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image_model.freezed.dart';
part 'product_image_model.g.dart';

@freezed
class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String id,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'alt_text') @Default('') String altText,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}
