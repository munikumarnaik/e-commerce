// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return _ProductCategory.fromJson(json);
}

/// @nodoc
mixin _$ProductCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  /// Serializes this ProductCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCategoryCopyWith<ProductCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCategoryCopyWith<$Res> {
  factory $ProductCategoryCopyWith(
          ProductCategory value, $Res Function(ProductCategory) then) =
      _$ProductCategoryCopyWithImpl<$Res, ProductCategory>;
  @useResult
  $Res call({String id, String name, String slug});
}

/// @nodoc
class _$ProductCategoryCopyWithImpl<$Res, $Val extends ProductCategory>
    implements $ProductCategoryCopyWith<$Res> {
  _$ProductCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductCategoryImplCopyWith<$Res>
    implements $ProductCategoryCopyWith<$Res> {
  factory _$$ProductCategoryImplCopyWith(_$ProductCategoryImpl value,
          $Res Function(_$ProductCategoryImpl) then) =
      __$$ProductCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String slug});
}

/// @nodoc
class __$$ProductCategoryImplCopyWithImpl<$Res>
    extends _$ProductCategoryCopyWithImpl<$Res, _$ProductCategoryImpl>
    implements _$$ProductCategoryImplCopyWith<$Res> {
  __$$ProductCategoryImplCopyWithImpl(
      _$ProductCategoryImpl _value, $Res Function(_$ProductCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_$ProductCategoryImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductCategoryImpl implements _ProductCategory {
  const _$ProductCategoryImpl(
      {required this.id, required this.name, required this.slug});

  factory _$ProductCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;

  @override
  String toString() {
    return 'ProductCategory(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      __$$ProductCategoryImplCopyWithImpl<_$ProductCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCategoryImplToJson(
      this,
    );
  }
}

abstract class _ProductCategory implements ProductCategory {
  const factory _ProductCategory(
      {required final String id,
      required final String name,
      required final String slug}) = _$ProductCategoryImpl;

  factory _ProductCategory.fromJson(Map<String, dynamic> json) =
      _$ProductCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;

  /// Create a copy of ProductCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductBrand _$ProductBrandFromJson(Map<String, dynamic> json) {
  return _ProductBrand.fromJson(json);
}

/// @nodoc
mixin _$ProductBrand {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;

  /// Serializes this ProductBrand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductBrandCopyWith<ProductBrand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductBrandCopyWith<$Res> {
  factory $ProductBrandCopyWith(
          ProductBrand value, $Res Function(ProductBrand) then) =
      _$ProductBrandCopyWithImpl<$Res, ProductBrand>;
  @useResult
  $Res call({String id, String name, String? logo});
}

/// @nodoc
class _$ProductBrandCopyWithImpl<$Res, $Val extends ProductBrand>
    implements $ProductBrandCopyWith<$Res> {
  _$ProductBrandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logo = freezed,
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
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductBrandImplCopyWith<$Res>
    implements $ProductBrandCopyWith<$Res> {
  factory _$$ProductBrandImplCopyWith(
          _$ProductBrandImpl value, $Res Function(_$ProductBrandImpl) then) =
      __$$ProductBrandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? logo});
}

/// @nodoc
class __$$ProductBrandImplCopyWithImpl<$Res>
    extends _$ProductBrandCopyWithImpl<$Res, _$ProductBrandImpl>
    implements _$$ProductBrandImplCopyWith<$Res> {
  __$$ProductBrandImplCopyWithImpl(
      _$ProductBrandImpl _value, $Res Function(_$ProductBrandImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logo = freezed,
  }) {
    return _then(_$ProductBrandImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductBrandImpl implements _ProductBrand {
  const _$ProductBrandImpl({required this.id, required this.name, this.logo});

  factory _$ProductBrandImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductBrandImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? logo;

  @override
  String toString() {
    return 'ProductBrand(id: $id, name: $name, logo: $logo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductBrandImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logo, logo) || other.logo == logo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, logo);

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductBrandImplCopyWith<_$ProductBrandImpl> get copyWith =>
      __$$ProductBrandImplCopyWithImpl<_$ProductBrandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductBrandImplToJson(
      this,
    );
  }
}

abstract class _ProductBrand implements ProductBrand {
  const factory _ProductBrand(
      {required final String id,
      required final String name,
      final String? logo}) = _$ProductBrandImpl;

  factory _ProductBrand.fromJson(Map<String, dynamic> json) =
      _$ProductBrandImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get logo;

  /// Create a copy of ProductBrand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductBrandImplCopyWith<_$ProductBrandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_type')
  String get productType => throw _privateConstructorUsedError;
  ProductCategory? get category => throw _privateConstructorUsedError;
  ProductBrand? get brand => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'variants_preview')
  List<ProductVariant> get variantsPreview =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'food_details')
  FoodDetails? get foodDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'clothing_details')
  ClothingDetails? get clothingDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      String? sku,
      @JsonKey(name: 'product_type') String productType,
      ProductCategory? category,
      ProductBrand? brand,
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
      @JsonKey(name: 'variants_preview') List<ProductVariant> variantsPreview,
      @JsonKey(name: 'food_details') FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at') String? createdAt});

  $ProductCategoryCopyWith<$Res>? get category;
  $ProductBrandCopyWith<$Res>? get brand;
  $FoodDetailsCopyWith<$Res>? get foodDetails;
  $ClothingDetailsCopyWith<$Res>? get clothingDetails;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
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
    Object? variantsPreview = null,
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
      variantsPreview: null == variantsPreview
          ? _value.variantsPreview
          : variantsPreview // ignore: cast_nullable_to_non_nullable
              as List<ProductVariant>,
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

  /// Create a copy of Product
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

  /// Create a copy of Product
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

  /// Create a copy of Product
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

  /// Create a copy of Product
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
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'variants_preview') List<ProductVariant> variantsPreview,
      @JsonKey(name: 'food_details') FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at') String? createdAt});

  @override
  $ProductCategoryCopyWith<$Res>? get category;
  @override
  $ProductBrandCopyWith<$Res>? get brand;
  @override
  $FoodDetailsCopyWith<$Res>? get foodDetails;
  @override
  $ClothingDetailsCopyWith<$Res>? get clothingDetails;
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
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
    Object? variantsPreview = null,
    Object? foodDetails = freezed,
    Object? clothingDetails = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ProductImpl(
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
      variantsPreview: null == variantsPreview
          ? _value._variantsPreview
          : variantsPreview // ignore: cast_nullable_to_non_nullable
              as List<ProductVariant>,
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
class _$ProductImpl implements _Product {
  const _$ProductImpl(
      {required this.id,
      required this.name,
      required this.slug,
      this.sku,
      @JsonKey(name: 'product_type') required this.productType,
      this.category,
      this.brand,
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
      @JsonKey(name: 'variants_preview')
      final List<ProductVariant> variantsPreview = const [],
      @JsonKey(name: 'food_details') this.foodDetails,
      @JsonKey(name: 'clothing_details') this.clothingDetails,
      @JsonKey(name: 'created_at') this.createdAt})
      : _images = images,
        _variantsPreview = variantsPreview;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

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
  final List<ProductVariant> _variantsPreview;
  @override
  @JsonKey(name: 'variants_preview')
  List<ProductVariant> get variantsPreview {
    if (_variantsPreview is EqualUnmodifiableListView) return _variantsPreview;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variantsPreview);
  }

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
    return 'Product(id: $id, name: $name, slug: $slug, sku: $sku, productType: $productType, category: $category, brand: $brand, description: $description, shortDescription: $shortDescription, price: $price, compareAtPrice: $compareAtPrice, discountPercentage: $discountPercentage, stockQuantity: $stockQuantity, trackInventory: $trackInventory, thumbnail: $thumbnail, images: $images, averageRating: $averageRating, totalReviews: $totalReviews, isFeatured: $isFeatured, isAvailable: $isAvailable, hasVariants: $hasVariants, variantsPreview: $variantsPreview, foodDetails: $foodDetails, clothingDetails: $clothingDetails, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
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
            const DeepCollectionEquality()
                .equals(other._variantsPreview, _variantsPreview) &&
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
        const DeepCollectionEquality().hash(_variantsPreview),
        foodDetails,
        clothingDetails,
        createdAt
      ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      required final String name,
      required final String slug,
      final String? sku,
      @JsonKey(name: 'product_type') required final String productType,
      final ProductCategory? category,
      final ProductBrand? brand,
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
      @JsonKey(name: 'variants_preview')
      final List<ProductVariant> variantsPreview,
      @JsonKey(name: 'food_details') final FoodDetails? foodDetails,
      @JsonKey(name: 'clothing_details') final ClothingDetails? clothingDetails,
      @JsonKey(name: 'created_at') final String? createdAt}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

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
  @JsonKey(name: 'variants_preview')
  List<ProductVariant> get variantsPreview;
  @override
  @JsonKey(name: 'food_details')
  FoodDetails? get foodDetails;
  @override
  @JsonKey(name: 'clothing_details')
  ClothingDetails? get clothingDetails;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
