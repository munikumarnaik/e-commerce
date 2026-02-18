// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartImpl _$$CartImplFromJson(Map<String, dynamic> json) => _$CartImpl(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: json['subtotal'] as String? ?? '0.00',
      tax: json['tax'] as String? ?? '0.00',
      deliveryFee: json['delivery_fee'] as String? ?? '0.00',
      discount: json['discount'] as String? ?? '0.00',
      total: json['total'] as String? ?? '0.00',
      couponCode: json['coupon_code'] as String?,
      couponDiscount: json['coupon_discount'] as String? ?? '0.00',
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CartImplToJson(_$CartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'delivery_fee': instance.deliveryFee,
      'discount': instance.discount,
      'total': instance.total,
      'coupon_code': instance.couponCode,
      'coupon_discount': instance.couponDiscount,
      'item_count': instance.itemCount,
    };
