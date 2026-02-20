// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String? ?? 'PENDING',
      paymentStatus: json['payment_status'] as String? ?? 'PENDING',
      paymentMethod: json['payment_method'] as String? ?? 'COD',
      subtotal: json['subtotal'] as String? ?? '0.00',
      tax: json['tax'] as String? ?? '0.00',
      deliveryFee: json['delivery_fee'] as String? ?? '0.00',
      discount: json['discount'] as String? ?? '0.00',
      total: json['total'] as String? ?? '0.00',
      couponCode: json['coupon_code'] as String?,
      customerNote: json['customer_note'] as String?,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shippingAddress: json['shipping_address'] as Map<String, dynamic>?,
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map(
                  (e) => OrderStatusHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'delivery_fee': instance.deliveryFee,
      'discount': instance.discount,
      'total': instance.total,
      'coupon_code': instance.couponCode,
      'customer_note': instance.customerNote,
      'items_count': instance.itemsCount,
      'items': instance.items,
      'shipping_address': instance.shippingAddress,
      'status_history': instance.statusHistory,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      productName: json['product_name'] as String? ?? '',
      productSlug: json['product_slug'] as String?,
      productThumbnail: json['product_thumbnail'] as String?,
      variantName: json['variant_name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: json['price'] as String? ?? '0.00',
      total: json['total'] as String? ?? '0.00',
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'product_slug': instance.productSlug,
      'product_thumbnail': instance.productThumbnail,
      'variant_name': instance.variantName,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
    };

_$OrderStatusHistoryImpl _$$OrderStatusHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusHistoryImpl(
      status: json['status'] as String,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$OrderStatusHistoryImplToJson(
        _$OrderStatusHistoryImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'note': instance.note,
      'created_at': instance.createdAt,
    };
