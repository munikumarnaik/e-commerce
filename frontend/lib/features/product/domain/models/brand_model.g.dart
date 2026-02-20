// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandImpl _$$BrandImplFromJson(Map<String, dynamic> json) => _$BrandImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$BrandImplToJson(_$BrandImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logo': instance.logo,
      'description': instance.description,
      'is_active': instance.isActive,
    };
