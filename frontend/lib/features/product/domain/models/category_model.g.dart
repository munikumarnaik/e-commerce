// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubCategoryImpl _$$SubCategoryImplFromJson(Map<String, dynamic> json) =>
    _$SubCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SubCategoryImplToJson(_$SubCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'product_count': instance.productCount,
    };

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      categoryType: json['category_type'] as String?,
      parent: json['parent'] as String?,
      image: json['image'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      subcategories: (json['subcategories'] as List<dynamic>?)
              ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'category_type': instance.categoryType,
      'parent': instance.parent,
      'image': instance.image,
      'icon': instance.icon,
      'description': instance.description,
      'display_order': instance.displayOrder,
      'product_count': instance.productCount,
      'subcategories': instance.subcategories,
    };
