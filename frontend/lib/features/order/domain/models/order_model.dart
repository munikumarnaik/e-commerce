import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    required String id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @Default('PENDING') String status,
    @JsonKey(name: 'payment_status') @Default('PENDING') String paymentStatus,
    @JsonKey(name: 'payment_method') @Default('COD') String paymentMethod,
    @Default('0.00') String subtotal,
    @Default('0.00') String tax,
    @JsonKey(name: 'delivery_fee') @Default('0.00') String deliveryFee,
    @Default('0.00') String discount,
    @Default('0.00') String total,
    @JsonKey(name: 'coupon_code') String? couponCode,
    @JsonKey(name: 'customer_note') String? customerNote,
    @JsonKey(name: 'items_count') @Default(0) int itemsCount,
    @Default([]) List<OrderItem> items,
    @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
    @JsonKey(name: 'status_history') @Default([]) List<OrderStatusHistory> statusHistory,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  double get totalValue => double.tryParse(total) ?? 0.0;
  double get subtotalValue => double.tryParse(subtotal) ?? 0.0;
  double get discountValue => double.tryParse(discount) ?? 0.0;

  bool get canCancel =>
      status == 'PENDING' || status == 'CONFIRMED' || status == 'PROCESSING';

  String get statusLabel => switch (status) {
        'PENDING' => 'Pending',
        'CONFIRMED' => 'Confirmed',
        'PROCESSING' => 'Processing',
        'SHIPPED' => 'Shipped',
        'OUT_FOR_DELIVERY' => 'Out for Delivery',
        'DELIVERED' => 'Delivered',
        'CANCELLED' => 'Cancelled',
        _ => status,
      };
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    @JsonKey(name: 'product_name') @Default('') String productName,
    @JsonKey(name: 'product_slug') String? productSlug,
    @JsonKey(name: 'product_thumbnail') String? productThumbnail,
    @JsonKey(name: 'variant_name') String? variantName,
    @Default(1) int quantity,
    @Default('0.00') String price,
    @Default('0.00') String total,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    required String status,
    String? note,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);
}
