// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductCategoryImpl _$$ProductCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$$ProductCategoryImplToJson(
        _$ProductCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_$ProductBrandImpl _$$ProductBrandImplFromJson(Map<String, dynamic> json) =>
    _$ProductBrandImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$$ProductBrandImplToJson(_$ProductBrandImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      sku: json['sku'] as String?,
      productType: json['product_type'] as String,
      category: json['category'] == null
          ? null
          : ProductCategory.fromJson(json['category'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : ProductBrand.fromJson(json['brand'] as Map<String, dynamic>),
      description: json['description'] as String?,
      shortDescription: json['short_description'] as String?,
      price: json['price'] as String,
      compareAtPrice: json['compare_at_price'] as String?,
      discountPercentage: json['discount_percentage'] as String?,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      trackInventory: json['track_inventory'] as bool? ?? true,
      thumbnail: json['thumbnail'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      averageRating: json['average_rating'] == null
          ? 0.0
          : parseDoubleField(json['average_rating']),
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      hasVariants: json['has_variants'] as bool? ?? false,
      variantsPreview: (json['variants_preview'] as List<dynamic>?)
              ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      foodDetails: json['food_details'] == null
          ? null
          : FoodDetails.fromJson(json['food_details'] as Map<String, dynamic>),
      clothingDetails: json['clothing_details'] == null
          ? null
          : ClothingDetails.fromJson(
              json['clothing_details'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'sku': instance.sku,
      'product_type': instance.productType,
      'category': instance.category,
      'brand': instance.brand,
      'description': instance.description,
      'short_description': instance.shortDescription,
      'price': instance.price,
      'compare_at_price': instance.compareAtPrice,
      'discount_percentage': instance.discountPercentage,
      'stock_quantity': instance.stockQuantity,
      'track_inventory': instance.trackInventory,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
      'average_rating': instance.averageRating,
      'total_reviews': instance.totalReviews,
      'is_featured': instance.isFeatured,
      'is_available': instance.isAvailable,
      'has_variants': instance.hasVariants,
      'variants_preview': instance.variantsPreview,
      'food_details': instance.foodDetails,
      'clothing_details': instance.clothingDetails,
      'created_at': instance.createdAt,
    };
