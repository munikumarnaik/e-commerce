// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVariantImpl _$$ProductVariantImplFromJson(Map<String, dynamic> json) =>
    _$ProductVariantImpl(
      id: json['id'] as String,
      sku: json['sku'] as String?,
      size: json['size'] as String? ?? '',
      color: json['color'] as String? ?? '',
      colorHex: json['color_hex'] as String?,
      price: json['price'] as String?,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ProductVariantImplToJson(
        _$ProductVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'size': instance.size,
      'color': instance.color,
      'color_hex': instance.colorHex,
      'price': instance.price,
      'stock_quantity': instance.stockQuantity,
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
    };
