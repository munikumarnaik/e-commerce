import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
class Cart with _$Cart {
  const Cart._();

  const factory Cart({
    required String id,
    @Default([]) List<CartItem> items,
    @JsonKey(name: 'subtotal') @Default('0.00') String subtotal,
    @JsonKey(name: 'tax') @Default('0.00') String tax,
    @JsonKey(name: 'delivery_fee') @Default('0.00') String deliveryFee,
    @JsonKey(name: 'discount') @Default('0.00') String discount,
    @JsonKey(name: 'total') @Default('0.00') String total,
    @JsonKey(name: 'coupon_code') String? couponCode,
    @JsonKey(name: 'coupon_discount') @Default('0.00') String couponDiscount,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  factory Cart.empty() => const Cart(id: '');

  double get subtotalValue => double.tryParse(subtotal) ?? 0.0;
  double get taxValue => double.tryParse(tax) ?? 0.0;
  double get deliveryFeeValue => double.tryParse(deliveryFee) ?? 0.0;
  double get discountValue => double.tryParse(discount) ?? 0.0;
  double get totalValue => double.tryParse(total) ?? 0.0;
  double get couponDiscountValue => double.tryParse(couponDiscount) ?? 0.0;
  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
