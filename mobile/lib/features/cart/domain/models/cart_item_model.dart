import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../product/domain/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required String id,
    @JsonKey(name: 'product') required CartProduct product,
    @JsonKey(name: 'variant') CartVariant? variant,
    required int quantity,
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'total_price') required String totalPrice,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  double get unitPriceValue => double.tryParse(unitPrice) ?? 0.0;
  double get totalPriceValue => double.tryParse(totalPrice) ?? 0.0;
}

@freezed
class CartProduct with _$CartProduct {
  const factory CartProduct({
    required String id,
    required String name,
    required String slug,
    // product_type is not returned in cart item snapshots; default to empty string
    @JsonKey(name: 'product_type') @Default('') String productType,
    String? thumbnail,
    // price is not returned in cart item snapshots (use CartItem.unitPrice instead)
    @Default('0.00') String price,
    @JsonKey(name: 'compare_at_price') String? compareAtPrice,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    ProductBrand? brand,
  }) = _CartProduct;

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);
}

@freezed
class CartVariant with _$CartVariant {
  const factory CartVariant({
    required String id,
    @Default('') String size,
    @Default('') String color,
    @JsonKey(name: 'color_hex') String? colorHex,
    String? price,
  }) = _CartVariant;

  factory CartVariant.fromJson(Map<String, dynamic> json) =>
      _$CartVariantFromJson(json);
}
