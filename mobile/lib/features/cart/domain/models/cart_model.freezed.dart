// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  String get id => throw _privateConstructorUsedError;
  List<CartItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal')
  String get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax')
  String get tax => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee')
  String get deliveryFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount')
  String get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total')
  String get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_code')
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_discount')
  String get couponDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemCount => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call(
      {String id,
      List<CartItem> items,
      @JsonKey(name: 'subtotal') String subtotal,
      @JsonKey(name: 'tax') String tax,
      @JsonKey(name: 'delivery_fee') String deliveryFee,
      @JsonKey(name: 'discount') String discount,
      @JsonKey(name: 'total') String total,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'coupon_discount') String couponDiscount,
      @JsonKey(name: 'items_count') int itemCount});
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? couponCode = freezed,
    Object? couponDiscount = null,
    Object? itemCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as String,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: null == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
          _$CartImpl value, $Res Function(_$CartImpl) then) =
      __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<CartItem> items,
      @JsonKey(name: 'subtotal') String subtotal,
      @JsonKey(name: 'tax') String tax,
      @JsonKey(name: 'delivery_fee') String deliveryFee,
      @JsonKey(name: 'discount') String discount,
      @JsonKey(name: 'total') String total,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'coupon_discount') String couponDiscount,
      @JsonKey(name: 'items_count') int itemCount});
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? couponCode = freezed,
    Object? couponDiscount = null,
    Object? itemCount = null,
  }) {
    return _then(_$CartImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as String,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: null == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as String,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl extends _Cart {
  const _$CartImpl(
      {required this.id,
      final List<CartItem> items = const [],
      @JsonKey(name: 'subtotal') this.subtotal = '0.00',
      @JsonKey(name: 'tax') this.tax = '0.00',
      @JsonKey(name: 'delivery_fee') this.deliveryFee = '0.00',
      @JsonKey(name: 'discount') this.discount = '0.00',
      @JsonKey(name: 'total') this.total = '0.00',
      @JsonKey(name: 'coupon_code') this.couponCode,
      @JsonKey(name: 'coupon_discount') this.couponDiscount = '0.00',
      @JsonKey(name: 'items_count') this.itemCount = 0})
      : _items = items,
        super._();

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final String id;
  final List<CartItem> _items;
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'subtotal')
  final String subtotal;
  @override
  @JsonKey(name: 'tax')
  final String tax;
  @override
  @JsonKey(name: 'delivery_fee')
  final String deliveryFee;
  @override
  @JsonKey(name: 'discount')
  final String discount;
  @override
  @JsonKey(name: 'total')
  final String total;
  @override
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  @override
  @JsonKey(name: 'coupon_discount')
  final String couponDiscount;
  @override
  @JsonKey(name: 'items_count')
  final int itemCount;

  @override
  String toString() {
    return 'Cart(id: $id, items: $items, subtotal: $subtotal, tax: $tax, deliveryFee: $deliveryFee, discount: $discount, total: $total, couponCode: $couponCode, couponDiscount: $couponDiscount, itemCount: $itemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.couponDiscount, couponDiscount) ||
                other.couponDiscount == couponDiscount) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      tax,
      deliveryFee,
      discount,
      total,
      couponCode,
      couponDiscount,
      itemCount);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(
      this,
    );
  }
}

abstract class _Cart extends Cart {
  const factory _Cart(
      {required final String id,
      final List<CartItem> items,
      @JsonKey(name: 'subtotal') final String subtotal,
      @JsonKey(name: 'tax') final String tax,
      @JsonKey(name: 'delivery_fee') final String deliveryFee,
      @JsonKey(name: 'discount') final String discount,
      @JsonKey(name: 'total') final String total,
      @JsonKey(name: 'coupon_code') final String? couponCode,
      @JsonKey(name: 'coupon_discount') final String couponDiscount,
      @JsonKey(name: 'items_count') final int itemCount}) = _$CartImpl;
  const _Cart._() : super._();

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  String get id;
  @override
  List<CartItem> get items;
  @override
  @JsonKey(name: 'subtotal')
  String get subtotal;
  @override
  @JsonKey(name: 'tax')
  String get tax;
  @override
  @JsonKey(name: 'delivery_fee')
  String get deliveryFee;
  @override
  @JsonKey(name: 'discount')
  String get discount;
  @override
  @JsonKey(name: 'total')
  String get total;
  @override
  @JsonKey(name: 'coupon_code')
  String? get couponCode;
  @override
  @JsonKey(name: 'coupon_discount')
  String get couponDiscount;
  @override
  @JsonKey(name: 'items_count')
  int get itemCount;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
