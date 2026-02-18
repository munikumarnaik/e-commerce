// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: json['id'] as String,
      product: CartProduct.fromJson(json['product'] as Map<String, dynamic>),
      variant: json['variant'] == null
          ? null
          : CartVariant.fromJson(json['variant'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unit_price'] as String,
      totalPrice: json['total_price'] as String,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'variant': instance.variant,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'created_at': instance.createdAt,
    };

_$CartProductImpl _$$CartProductImplFromJson(Map<String, dynamic> json) =>
    _$CartProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      productType: json['product_type'] as String,
      thumbnail: json['thumbnail'] as String?,
      price: json['price'] as String,
      compareAtPrice: json['compare_at_price'] as String?,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      brand: json['brand'] == null
          ? null
          : ProductBrand.fromJson(json['brand'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CartProductImplToJson(_$CartProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'product_type': instance.productType,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'compare_at_price': instance.compareAtPrice,
      'stock_quantity': instance.stockQuantity,
      'is_available': instance.isAvailable,
      'brand': instance.brand,
    };

_$CartVariantImpl _$$CartVariantImplFromJson(Map<String, dynamic> json) =>
    _$CartVariantImpl(
      id: json['id'] as String,
      size: json['size'] as String? ?? '',
      color: json['color'] as String? ?? '',
      colorHex: json['color_hex'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$$CartVariantImplToJson(_$CartVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'size': instance.size,
      'color': instance.color,
      'color_hex': instance.colorHex,
      'price': instance.price,
    };
