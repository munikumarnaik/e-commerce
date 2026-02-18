// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product')
  CartProduct get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'variant')
  CartVariant? get variant => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  String get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product') CartProduct product,
      @JsonKey(name: 'variant') CartVariant? variant,
      int quantity,
      @JsonKey(name: 'unit_price') String unitPrice,
      @JsonKey(name: 'total_price') String totalPrice,
      @JsonKey(name: 'created_at') String? createdAt});

  $CartProductCopyWith<$Res> get product;
  $CartVariantCopyWith<$Res>? get variant;
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? variant = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as CartProduct,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as CartVariant?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartProductCopyWith<$Res> get product {
    return $CartProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartVariantCopyWith<$Res>? get variant {
    if (_value.variant == null) {
      return null;
    }

    return $CartVariantCopyWith<$Res>(_value.variant!, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product') CartProduct product,
      @JsonKey(name: 'variant') CartVariant? variant,
      int quantity,
      @JsonKey(name: 'unit_price') String unitPrice,
      @JsonKey(name: 'total_price') String totalPrice,
      @JsonKey(name: 'created_at') String? createdAt});

  @override
  $CartProductCopyWith<$Res> get product;
  @override
  $CartVariantCopyWith<$Res>? get variant;
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? variant = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$CartItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as CartProduct,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as CartVariant?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl extends _CartItem {
  const _$CartItemImpl(
      {required this.id,
      @JsonKey(name: 'product') required this.product,
      @JsonKey(name: 'variant') this.variant,
      required this.quantity,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'total_price') required this.totalPrice,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product')
  final CartProduct product;
  @override
  @JsonKey(name: 'variant')
  final CartVariant? variant;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  @override
  @JsonKey(name: 'total_price')
  final String totalPrice;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'CartItem(id: $id, product: $product, variant: $variant, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, product, variant, quantity,
      unitPrice, totalPrice, createdAt);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem extends CartItem {
  const factory _CartItem(
      {required final String id,
      @JsonKey(name: 'product') required final CartProduct product,
      @JsonKey(name: 'variant') final CartVariant? variant,
      required final int quantity,
      @JsonKey(name: 'unit_price') required final String unitPrice,
      @JsonKey(name: 'total_price') required final String totalPrice,
      @JsonKey(name: 'created_at') final String? createdAt}) = _$CartItemImpl;
  const _CartItem._() : super._();

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product')
  CartProduct get product;
  @override
  @JsonKey(name: 'variant')
  CartVariant? get variant;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price')
  String get unitPrice;
  @override
  @JsonKey(name: 'total_price')
  String get totalPrice;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartProduct _$CartProductFromJson(Map<String, dynamic> json) {
  return _CartProduct.fromJson(json);
}

/// @nodoc
mixin _$CartProduct {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug =>
      throw _privateConstructorUsedError; // product_type is not returned in cart item snapshots; default to empty string
  @JsonKey(name: 'product_type')
  String get productType => throw _privateConstructorUsedError;
  String? get thumbnail =>
      throw _privateConstructorUsedError; // price is not returned in cart item snapshots (use CartItem.unitPrice instead)
  String get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'compare_at_price')
  String? get compareAtPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  ProductBrand? get brand => throw _privateConstructorUsedError;

  /// Serializes this CartProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartProductCopyWith<CartProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartProductCopyWith<$Res> {
  factory $CartProductCopyWith(
          CartProduct value, $Res Function(CartProduct) then) =
      _$CartProductCopyWithImpl<$Res, CartProduct>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'product_type') String productType,
      String? thumbnail,
      String price,
      @JsonKey(name: 'compare_at_price') String? compareAtPrice,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'is_available') bool isAvailable,
      ProductBrand? brand});

  $ProductBrandCopyWith<$Res>? get brand;
}

/// @nodoc
class _$CartProductCopyWithImpl<$Res, $Val extends CartProduct>
    implements $CartProductCopyWith<$Res> {
  _$CartProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? productType = null,
    Object? thumbnail = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? stockQuantity = null,
    Object? isAvailable = null,
    Object? brand = freezed,
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
      productType: null == productType
          ? _value.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as ProductBrand?,
    ) as $Val);
  }

  /// Create a copy of CartProduct
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
}

/// @nodoc
abstract class _$$CartProductImplCopyWith<$Res>
    implements $CartProductCopyWith<$Res> {
  factory _$$CartProductImplCopyWith(
          _$CartProductImpl value, $Res Function(_$CartProductImpl) then) =
      __$$CartProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'product_type') String productType,
      String? thumbnail,
      String price,
      @JsonKey(name: 'compare_at_price') String? compareAtPrice,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'is_available') bool isAvailable,
      ProductBrand? brand});

  @override
  $ProductBrandCopyWith<$Res>? get brand;
}

/// @nodoc
class __$$CartProductImplCopyWithImpl<$Res>
    extends _$CartProductCopyWithImpl<$Res, _$CartProductImpl>
    implements _$$CartProductImplCopyWith<$Res> {
  __$$CartProductImplCopyWithImpl(
      _$CartProductImpl _value, $Res Function(_$CartProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? productType = null,
    Object? thumbnail = freezed,
    Object? price = null,
    Object? compareAtPrice = freezed,
    Object? stockQuantity = null,
    Object? isAvailable = null,
    Object? brand = freezed,
  }) {
    return _then(_$CartProductImpl(
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
      productType: null == productType
          ? _value.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      compareAtPrice: freezed == compareAtPrice
          ? _value.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as ProductBrand?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartProductImpl implements _CartProduct {
  const _$CartProductImpl(
      {required this.id,
      required this.name,
      required this.slug,
      @JsonKey(name: 'product_type') this.productType = '',
      this.thumbnail,
      this.price = '0.00',
      @JsonKey(name: 'compare_at_price') this.compareAtPrice,
      @JsonKey(name: 'stock_quantity') this.stockQuantity = 0,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      this.brand});

  factory _$CartProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
// product_type is not returned in cart item snapshots; default to empty string
  @override
  @JsonKey(name: 'product_type')
  final String productType;
  @override
  final String? thumbnail;
// price is not returned in cart item snapshots (use CartItem.unitPrice instead)
  @override
  @JsonKey()
  final String price;
  @override
  @JsonKey(name: 'compare_at_price')
  final String? compareAtPrice;
  @override
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  final ProductBrand? brand;

  @override
  String toString() {
    return 'CartProduct(id: $id, name: $name, slug: $slug, productType: $productType, thumbnail: $thumbnail, price: $price, compareAtPrice: $compareAtPrice, stockQuantity: $stockQuantity, isAvailable: $isAvailable, brand: $brand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.brand, brand) || other.brand == brand));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, productType,
      thumbnail, price, compareAtPrice, stockQuantity, isAvailable, brand);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      __$$CartProductImplCopyWithImpl<_$CartProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartProductImplToJson(
      this,
    );
  }
}

abstract class _CartProduct implements CartProduct {
  const factory _CartProduct(
      {required final String id,
      required final String name,
      required final String slug,
      @JsonKey(name: 'product_type') final String productType,
      final String? thumbnail,
      final String price,
      @JsonKey(name: 'compare_at_price') final String? compareAtPrice,
      @JsonKey(name: 'stock_quantity') final int stockQuantity,
      @JsonKey(name: 'is_available') final bool isAvailable,
      final ProductBrand? brand}) = _$CartProductImpl;

  factory _CartProduct.fromJson(Map<String, dynamic> json) =
      _$CartProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String
      get slug; // product_type is not returned in cart item snapshots; default to empty string
  @override
  @JsonKey(name: 'product_type')
  String get productType;
  @override
  String?
      get thumbnail; // price is not returned in cart item snapshots (use CartItem.unitPrice instead)
  @override
  String get price;
  @override
  @JsonKey(name: 'compare_at_price')
  String? get compareAtPrice;
  @override
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  ProductBrand? get brand;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartVariant _$CartVariantFromJson(Map<String, dynamic> json) {
  return _CartVariant.fromJson(json);
}

/// @nodoc
mixin _$CartVariant {
  String get id => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'color_hex')
  String? get colorHex => throw _privateConstructorUsedError;
  String? get price => throw _privateConstructorUsedError;

  /// Serializes this CartVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartVariantCopyWith<CartVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartVariantCopyWith<$Res> {
  factory $CartVariantCopyWith(
          CartVariant value, $Res Function(CartVariant) then) =
      _$CartVariantCopyWithImpl<$Res, CartVariant>;
  @useResult
  $Res call(
      {String id,
      String size,
      String color,
      @JsonKey(name: 'color_hex') String? colorHex,
      String? price});
}

/// @nodoc
class _$CartVariantCopyWithImpl<$Res, $Val extends CartVariant>
    implements $CartVariantCopyWith<$Res> {
  _$CartVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? colorHex = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartVariantImplCopyWith<$Res>
    implements $CartVariantCopyWith<$Res> {
  factory _$$CartVariantImplCopyWith(
          _$CartVariantImpl value, $Res Function(_$CartVariantImpl) then) =
      __$$CartVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String size,
      String color,
      @JsonKey(name: 'color_hex') String? colorHex,
      String? price});
}

/// @nodoc
class __$$CartVariantImplCopyWithImpl<$Res>
    extends _$CartVariantCopyWithImpl<$Res, _$CartVariantImpl>
    implements _$$CartVariantImplCopyWith<$Res> {
  __$$CartVariantImplCopyWithImpl(
      _$CartVariantImpl _value, $Res Function(_$CartVariantImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? colorHex = freezed,
    Object? price = freezed,
  }) {
    return _then(_$CartVariantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartVariantImpl implements _CartVariant {
  const _$CartVariantImpl(
      {required this.id,
      this.size = '',
      this.color = '',
      @JsonKey(name: 'color_hex') this.colorHex,
      this.price});

  factory _$CartVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartVariantImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String size;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey(name: 'color_hex')
  final String? colorHex;
  @override
  final String? price;

  @override
  String toString() {
    return 'CartVariant(id: $id, size: $size, color: $color, colorHex: $colorHex, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, size, color, colorHex, price);

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartVariantImplCopyWith<_$CartVariantImpl> get copyWith =>
      __$$CartVariantImplCopyWithImpl<_$CartVariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartVariantImplToJson(
      this,
    );
  }
}

abstract class _CartVariant implements CartVariant {
  const factory _CartVariant(
      {required final String id,
      final String size,
      final String color,
      @JsonKey(name: 'color_hex') final String? colorHex,
      final String? price}) = _$CartVariantImpl;

  factory _CartVariant.fromJson(Map<String, dynamic> json) =
      _$CartVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get size;
  @override
  String get color;
  @override
  @JsonKey(name: 'color_hex')
  String? get colorHex;
  @override
  String? get price;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartVariantImplCopyWith<_$CartVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
