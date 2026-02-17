// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductVendor _$ProductVendorFromJson(Map<String, dynamic> json) {
  return _ProductVendor.fromJson(json);
}

/// @nodoc
mixin _$ProductVendor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this ProductVendor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductVendor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductVendorCopyWith<ProductVendor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVendorCopyWith<$Res> {
  factory $ProductVendorCopyWith(
          ProductVendor value, $Res Function(ProductVendor) then) =
      _$ProductVendorCopyWithImpl<$Res, ProductVendor>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'profile_image') String? profileImage});
}

/// @nodoc
class _$ProductVendorCopyWithImpl<$Res, $Val extends ProductVendor>
    implements $ProductVendorCopyWith<$Res> {
  _$ProductVendorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductVendor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductVendorImplCopyWith<$Res>
    implements $ProductVendorCopyWith<$Res> {
  factory _$$ProductVendorImplCopyWith(
          _$ProductVendorImpl value, $Res Function(_$ProductVendorImpl) then) =
      __$$ProductVendorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'profile_image') String? profileImage});
}

/// @nodoc
class __$$ProductVendorImplCopyWithImpl<$Res>
    extends _$ProductVendorCopyWithImpl<$Res, _$ProductVendorImpl>
    implements _$$ProductVendorImplCopyWith<$Res> {
  __$$ProductVendorImplCopyWithImpl(
      _$ProductVendorImpl _value, $Res Function(_$ProductVendorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductVendor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_$ProductVendorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductVendorImpl implements _ProductVendor {
  const _$ProductVendorImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'profile_image') this.profileImage});

  factory _$ProductVendorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVendorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @override
  String toString() {
    return 'ProductVendor(id: $id, name: $name, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVendorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  /// Create a copy of ProductVendor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVendorImplCopyWith<_$ProductVendorImpl> get copyWith =>
      __$$ProductVendorImplCopyWithImpl<_$ProductVendorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVendorImplToJson(
      this,
    );
  }
}

abstract class _ProductVendor implements ProductVendor {
  const factory _ProductVendor(
          {required final String id,
          required final String name,
          @JsonKey(name: 'profile_image') final String? profileImage}) =
      _$ProductVendorImpl;

  factory _ProductVendor.fromJson(Map<String, dynamic> json) =
      _$ProductVendorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;

  /// Create a copy of ProductVendor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductVendorImplCopyWith<_$ProductVendorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) {
  return _ProductDetail.fromJson(json);
}

/// @nodoc
mixin _$ProductDetail {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  String get productType => throw _privateConstructorUsedError;
  ProductCategory? get category => throw _privateConstructorUsedError;
  ProductBrand? get brand => throw _privateConstructorUsedError;
  ProductVendor? get vendor => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_description')
  String? get shortDescription => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'compare_at_price')
  String? get compareAtPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_percentage')
  String? get discountPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'track_inventory')
  bool get trackInventory => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  List<ProductImage> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating')
  double get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_variants')
  bool get hasVariants => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_details')
  FoodDetails? get foodDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'clothing_details')
  ClothingDetails? get clothingDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProductDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailCopyWith<ProductDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailCopyWith<$Res> {
  factory $ProductDetailCopyWith(
          ProductDetail value, $Res Function(ProductDetail) then) =
      _$ProductDetailCopyWithImpl<$Res, ProductDetail>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      String? sku,
      @JsonKey(name: 'product_type') String productType,
      ProductCategory? category,
      ProductBrand? brand,
      ProductVendor? vendor,
      String? description,
      @JsonKey(name: 'short_description') String? shortDescription,
      String price,
      @JsonKey(name: 'compare_at_price') String? compareAtPrice,
      @JsonKey(name: 'discount_percentage') String? discountPercentage,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'track_inventory') bool trackInventory,
      String? thumbnail,
      List<ProductImage> images,
      @JsonKey(name: 'average_rating') double averageRating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'has_variants') bool hasVariants,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'food_details') FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at') String? createdAt});

  $ProductCategoryCopyWith<$Res>? get category;
  $ProductBrandCopyWith<$Res>? get brand;
  $ProductVendorCopyWith<$Res>? get vendor;
  $FoodDetailsCopyWith<$Res>? get foodDetails;
  $ClothingDetailsCopyWith<$Res>? get clothingDetails;
}

/// @nodoc
class _$ProductDetailCopyWithImpl<$Res, $Val extends ProductDetail>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? sku = freezed,
    Object? productType = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? vendor = freezed,
    Object? description = freezed,
    Object? shortDescription = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? discountPercentage = freezed,
    Object? stockQuantity = null,
    Object? trackInventory = null,
    Object? thumbnail = freezed,
    Object? images = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? isFeatured = null,
    Object? isAvailable = null,
    Object? hasVariants = null,
    Object? viewCount = null,
    Object? foodDetails = freezed,
    Object? clothingDetails = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productType: null == productType
          ? _value.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as ProductBrand?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as ProductVendor?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      trackInventory: null == trackInventory
          ? _value.trackInventory
          : trackInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      foodDetails: freezed == foodDetails
          ? _value.foodDetails
          : foodDetails // ignore: cast_nullable_to_non_nullable
              as FoodDetails?,
      clothingDetails: freezed == clothingDetails
          ? _value.clothingDetails
          : clothingDetails // ignore: cast_nullable_to_non_nullable
              as ClothingDetails?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $ProductCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductBrandCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $ProductBrandCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductVendorCopyWith<$Res>? get vendor {
    if (_value.vendor == null) {
      return null;
    }

    return $ProductVendorCopyWith<$Res>(_value.vendor!, (value) {
      return _then(_value.copyWith(vendor: value) as $Val);
    });
  }

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodDetailsCopyWith<$Res>? get foodDetails {
    if (_value.foodDetails == null) {
      return null;
    }

    return $FoodDetailsCopyWith<$Res>(_value.foodDetails!, (value) {
      return _then(_value.copyWith(foodDetails: value) as $Val);
    });
  }

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClothingDetailsCopyWith<$Res>? get clothingDetails {
    if (_value.clothingDetails == null) {
      return null;
    }

    return $ClothingDetailsCopyWith<$Res>(_value.clothingDetails!, (value) {
      return _then(_value.copyWith(clothingDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductDetailImplCopyWith<$Res>
    implements $ProductDetailCopyWith<$Res> {
  factory _$$ProductDetailImplCopyWith(
          _$ProductDetailImpl value, $Res Function(_$ProductDetailImpl) then) =
      __$$ProductDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      String? sku,
      @JsonKey(name: 'product_type') String productType,
      ProductCategory? category,
      ProductBrand? brand,
      ProductVendor? vendor,
      String? description,
      @JsonKey(name: 'short_description') String? shortDescription,
      String price,
      @JsonKey(name: 'compare_at_price') String? compareAtPrice,
      @JsonKey(name: 'discount_percentage') String? discountPercentage,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'track_inventory') bool trackInventory,
      String? thumbnail,
      List<ProductImage> images,
      @JsonKey(name: 'average_rating') double averageRating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'has_variants') bool hasVariants,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'food_details') FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at') String? createdAt});

  @override
  $ProductCategoryCopyWith<$Res>? get category;
  @override
  $ProductBrandCopyWith<$Res>? get brand;
  @override
  $ProductVendorCopyWith<$Res>? get vendor;
  @override
  $FoodDetailsCopyWith<$Res>? get foodDetails;
  @override
  $ClothingDetailsCopyWith<$Res>? get clothingDetails;
}

/// @nodoc
class __$$ProductDetailImplCopyWithImpl<$Res>
    extends _$ProductDetailCopyWithImpl<$Res, _$ProductDetailImpl>
    implements _$$ProductDetailImplCopyWith<$Res> {
  __$$ProductDetailImplCopyWithImpl(
      _$ProductDetailImpl _value, $Res Function(_$ProductDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? sku = freezed,
    Object? productType = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? vendor = freezed,
    Object? description = freezed,
    Object? shortDescription = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? discountPercentage = freezed,
    Object? stockQuantity = null,
    Object? trackInventory = null,
    Object? thumbnail = freezed,
    Object? images = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? isFeatured = null,
    Object? isAvailable = null,
    Object? hasVariants = null,
    Object? viewCount = null,
    Object? foodDetails = freezed,
    Object? clothingDetails = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ProductDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productType: null == productType
          ? _value.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as ProductBrand?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as ProductVendor?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      trackInventory: null == trackInventory
          ? _value.trackInventory
          : trackInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      foodDetails: freezed == foodDetails
          ? _value.foodDetails
          : foodDetails // ignore: cast_nullable_to_non_nullable
              as FoodDetails?,
      clothingDetails: freezed == clothingDetails
          ? _value.clothingDetails
          : clothingDetails // ignore: cast_nullable_to_non_nullable
              as ClothingDetails?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductDetailImpl implements _ProductDetail {
  const _$ProductDetailImpl(
      {required this.id,
      required this.name,
      required this.slug,
      this.sku,
      @JsonKey(name: 'product_type') required this.productType,
      this.category,
      this.brand,
      this.vendor,
      this.description,
      @JsonKey(name: 'short_description') this.shortDescription,
      required this.price,
      @JsonKey(name: 'compare_at_price') this.compareAtPrice,
      @JsonKey(name: 'discount_percentage') this.discountPercentage,
      @JsonKey(name: 'stock_quantity') this.stockQuantity = 0,
      @JsonKey(name: 'track_inventory') this.trackInventory = true,
      this.thumbnail,
      final List<ProductImage> images = const [],
      @JsonKey(name: 'average_rating') this.averageRating = 0.0,
      @JsonKey(name: 'total_reviews') this.totalReviews = 0,
      @JsonKey(name: 'is_featured') this.isFeatured = false,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'has_variants') this.hasVariants = false,
      @JsonKey(name: 'view_count') this.viewCount = 0,
      @JsonKey(name: 'food_details') this.foodDetails,
      @JsonKey(name: 'clothing_details') this.clothingDetails,
      @JsonKey(name: 'created_at') this.createdAt})
      : _images = images;

  factory _$ProductDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? sku;
  @override
  @JsonKey(name: 'product_type')
  final String productType;
  @override
  final ProductCategory? category;
  @override
  final ProductBrand? brand;
  @override
  final ProductVendor? vendor;
  @override
  final String? description;
  @override
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  @override
  final String price;
  @override
  @JsonKey(name: 'compare_at_price')
  final String? compareAtPrice;
  @override
  @JsonKey(name: 'discount_percentage')
  final String? discountPercentage;
  @override
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @override
  @JsonKey(name: 'track_inventory')
  final bool trackInventory;
  @override
  final String? thumbnail;
  final List<ProductImage> _images;
  @override
  @JsonKey()
  List<ProductImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'average_rating')
  final double averageRating;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'has_variants')
  final bool hasVariants;
  @override
  @JsonKey(name: 'view_count')
  final int viewCount;
  @override
  @JsonKey(name: 'food_details')
  final FoodDetails? foodDetails;
  @override
  @JsonKey(name: 'clothing_details')
  final ClothingDetails? clothingDetails;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ProductDetail(id: $id, name: $name, slug: $slug, sku: $sku, productType: $productType, category: $category, brand: $brand, vendor: $vendor, description: $description, shortDescription: $shortDescription, price: $price, compareAtPrice: $compareAtPrice, discountPercentage: $discountPercentage, stockQuantity: $stockQuantity, trackInventory: $trackInventory, thumbnail: $thumbnail, images: $images, averageRating: $averageRating, totalReviews: $totalReviews, isFeatured: $isFeatured, isAvailable: $isAvailable, hasVariants: $hasVariants, viewCount: $viewCount, foodDetails: $foodDetails, clothingDetails: $clothingDetails, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.trackInventory, trackInventory) ||
                other.trackInventory == trackInventory) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.foodDetails, foodDetails) ||
                other.foodDetails == foodDetails) &&
            (identical(other.clothingDetails, clothingDetails) ||
                other.clothingDetails == clothingDetails) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        sku,
        productType,
        category,
        brand,
        vendor,
        description,
        shortDescription,
        price,
        compareAtPrice,
        discountPercentage,
        stockQuantity,
        trackInventory,
        thumbnail,
        const DeepCollectionEquality().hash(_images),
        averageRating,
        totalReviews,
        isFeatured,
        isAvailable,
        hasVariants,
        viewCount,
        foodDetails,
        clothingDetails,
        createdAt
      ]);

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailImplCopyWith<_$ProductDetailImpl> get copyWith =>
      __$$ProductDetailImplCopyWithImpl<_$ProductDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductDetailImplToJson(
      this,
    );
  }
}

abstract class _ProductDetail implements ProductDetail {
  const factory _ProductDetail(
      {required final String id,
      required final String name,
      required final String slug,
      final String? sku,
      @JsonKey(name: 'product_type') required final String productType,
      final ProductCategory? category,
      final ProductBrand? brand,
      final ProductVendor? vendor,
      final String? description,
      @JsonKey(name: 'short_description') final String? shortDescription,
      required final String price,
      @JsonKey(name: 'compare_at_price') final String? compareAtPrice,
      @JsonKey(name: 'discount_percentage') final String? discountPercentage,
      @JsonKey(name: 'stock_quantity') final int stockQuantity,
      @JsonKey(name: 'track_inventory') final bool trackInventory,
      final String? thumbnail,
      final List<ProductImage> images,
      @JsonKey(name: 'average_rating') final double averageRating,
      @JsonKey(name: 'total_reviews') final int totalReviews,
      @JsonKey(name: 'is_featured') final bool isFeatured,
      @JsonKey(name: 'is_available') final bool isAvailable,
      @JsonKey(name: 'has_variants') final bool hasVariants,
      @JsonKey(name: 'view_count') final int viewCount,
      @JsonKey(name: 'food_details') final FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') final ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at')
      final String? createdAt}) = _$ProductDetailImpl;

  factory _ProductDetail.fromJson(Map<String, dynamic> json) =
      _$ProductDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get sku;
  @override
  @JsonKey(name: 'product_type')
  String get productType;
  @override
  ProductCategory? get category;
  @override
  ProductBrand? get brand;
  @override
  ProductVendor? get vendor;
  @override
  String? get description;
  @override
  @JsonKey(name: 'short_description')
  String? get shortDescription;
  @override
  String get price;
  @override
  @JsonKey(name: 'compare_at_price')
  String? get compareAtPrice;
  @override
  @JsonKey(name: 'discount_percentage')
  String? get discountPercentage;
  @override
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity;
  @override
  @JsonKey(name: 'track_inventory')
  bool get trackInventory;
  @override
  String? get thumbnail;
  @override
  List<ProductImage> get images;
  @override
  @JsonKey(name: 'average_rating')
  double get averageRating;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'has_variants')
  bool get hasVariants;
  @override
  @JsonKey(name: 'view_count')
  int get viewCount;
  @override
  @JsonKey(name: 'food_details')
  FoodDetails? get foodDetails;
  @override
  @JsonKey(name: 'clothing_details')
  ClothingDetails? get clothingDetails;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ProductDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailImplCopyWith<_$ProductDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
