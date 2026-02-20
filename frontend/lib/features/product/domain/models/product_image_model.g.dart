// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImageImpl _$$ProductImageImplFromJson(Map<String, dynamic> json) =>
    _$ProductImageImpl(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String? ?? '',
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductImageImplToJson(_$ProductImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'alt_text': instance.altText,
      'display_order': instance.displayOrder,
      'is_primary': instance.isPrimary,
    };
