// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVendorImpl _$$ProductVendorImplFromJson(Map<String, dynamic> json) =>
    _$ProductVendorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$$ProductVendorImplToJson(_$ProductVendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image': instance.profileImage,
    };

_$ProductDetailImpl _$$ProductDetailImplFromJson(Map<String, dynamic> json) =>
    _$ProductDetailImpl(
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
      vendor: json['vendor'] == null
          ? null
          : ProductVendor.fromJson(json['vendor'] as Map<String, dynamic>),
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
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      hasVariants: json['has_variants'] as bool? ?? false,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      foodDetails: json['food_details'] == null
          ? null
          : FoodDetails.fromJson(json['food_details'] as Map<String, dynamic>),
      clothingDetails: json['clothing_details'] == null
          ? null
          : ClothingDetails.fromJson(
              json['clothing_details'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ProductDetailImplToJson(_$ProductDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'sku': instance.sku,
      'product_type': instance.productType,
      'category': instance.category,
      'brand': instance.brand,
      'vendor': instance.vendor,
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
      'view_count': instance.viewCount,
      'food_details': instance.foodDetails,
      'clothing_details': instance.clothingDetails,
      'created_at': instance.createdAt,
    };
