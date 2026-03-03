// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  String get subtotal => throw _privateConstructorUsedError;
  String get tax => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_cost')
  String get deliveryFee => throw _privateConstructorUsedError;
  String get discount => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_code')
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_note')
  String? get customerNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemsCount => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'status_history')
  List<OrderStatusHistory> get statusHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'order_number') String orderNumber,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_method') String paymentMethod,
      String subtotal,
      String tax,
      @JsonKey(name: 'shipping_cost') String deliveryFee,
      String discount,
      String total,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'customer_note') String? customerNote,
      @JsonKey(name: 'items_count') int itemsCount,
      List<OrderItem> items,
      @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
      @JsonKey(name: 'status_history') List<OrderStatusHistory> statusHistory,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? couponCode = freezed,
    Object? customerNote = freezed,
    Object? itemsCount = null,
    Object? items = null,
    Object? shippingAddress = freezed,
    Object? statusHistory = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
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
      customerNote: freezed == customerNote
          ? _value.customerNote
          : customerNote // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusHistory>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'order_number') String orderNumber,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_method') String paymentMethod,
      String subtotal,
      String tax,
      @JsonKey(name: 'shipping_cost') String deliveryFee,
      String discount,
      String total,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'customer_note') String? customerNote,
      @JsonKey(name: 'items_count') int itemsCount,
      List<OrderItem> items,
      @JsonKey(name: 'shipping_address') Map<String, dynamic>? shippingAddress,
      @JsonKey(name: 'status_history') List<OrderStatusHistory> statusHistory,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? couponCode = freezed,
    Object? customerNote = freezed,
    Object? itemsCount = null,
    Object? items = null,
    Object? shippingAddress = freezed,
    Object? statusHistory = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
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
      customerNote: freezed == customerNote
          ? _value.customerNote
          : customerNote // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      shippingAddress: freezed == shippingAddress
          ? _value._shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusHistory>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl extends _Order {
  const _$OrderImpl(
      {required this.id,
      @JsonKey(name: 'order_number') required this.orderNumber,
      this.status = 'PENDING',
      @JsonKey(name: 'payment_status') this.paymentStatus = 'PENDING',
      @JsonKey(name: 'payment_method') this.paymentMethod = 'COD',
      this.subtotal = '0.00',
      this.tax = '0.00',
      @JsonKey(name: 'shipping_cost') this.deliveryFee = '0.00',
      this.discount = '0.00',
      this.total = '0.00',
      @JsonKey(name: 'coupon_code') this.couponCode,
      @JsonKey(name: 'customer_note') this.customerNote,
      @JsonKey(name: 'items_count') this.itemsCount = 0,
      final List<OrderItem> items = const [],
      @JsonKey(name: 'shipping_address')
      final Map<String, dynamic>? shippingAddress,
      @JsonKey(name: 'status_history')
      final List<OrderStatusHistory> statusHistory = const [],
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _items = items,
        _shippingAddress = shippingAddress,
        _statusHistory = statusHistory,
        super._();

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey()
  final String subtotal;
  @override
  @JsonKey()
  final String tax;
  @override
  @JsonKey(name: 'shipping_cost')
  final String deliveryFee;
  @override
  @JsonKey()
  final String discount;
  @override
  @JsonKey()
  final String total;
  @override
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  @override
  @JsonKey(name: 'customer_note')
  final String? customerNote;
  @override
  @JsonKey(name: 'items_count')
  final int itemsCount;
  final List<OrderItem> _items;
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, dynamic>? _shippingAddress;
  @override
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress {
    final value = _shippingAddress;
    if (value == null) return null;
    if (_shippingAddress is EqualUnmodifiableMapView) return _shippingAddress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<OrderStatusHistory> _statusHistory;
  @override
  @JsonKey(name: 'status_history')
  List<OrderStatusHistory> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, tax: $tax, deliveryFee: $deliveryFee, discount: $discount, total: $total, couponCode: $couponCode, customerNote: $customerNote, itemsCount: $itemsCount, items: $items, shippingAddress: $shippingAddress, statusHistory: $statusHistory, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
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
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._shippingAddress, _shippingAddress) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      status,
      paymentStatus,
      paymentMethod,
      subtotal,
      tax,
      deliveryFee,
      discount,
      total,
      couponCode,
      customerNote,
      itemsCount,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_shippingAddress),
      const DeepCollectionEquality().hash(_statusHistory),
      createdAt,
      updatedAt);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order extends Order {
  const factory _Order(
      {required final String id,
      @JsonKey(name: 'order_number') required final String orderNumber,
      final String status,
      @JsonKey(name: 'payment_status') final String paymentStatus,
      @JsonKey(name: 'payment_method') final String paymentMethod,
      final String subtotal,
      final String tax,
      @JsonKey(name: 'shipping_cost') final String deliveryFee,
      final String discount,
      final String total,
      @JsonKey(name: 'coupon_code') final String? couponCode,
      @JsonKey(name: 'customer_note') final String? customerNote,
      @JsonKey(name: 'items_count') final int itemsCount,
      final List<OrderItem> items,
      @JsonKey(name: 'shipping_address')
      final Map<String, dynamic>? shippingAddress,
      @JsonKey(name: 'status_history')
      final List<OrderStatusHistory> statusHistory,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt}) = _$OrderImpl;
  const _Order._() : super._();

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  String get subtotal;
  @override
  String get tax;
  @override
  @JsonKey(name: 'shipping_cost')
  String get deliveryFee;
  @override
  String get discount;
  @override
  String get total;
  @override
  @JsonKey(name: 'coupon_code')
  String? get couponCode;
  @override
  @JsonKey(name: 'customer_note')
  String? get customerNote;
  @override
  @JsonKey(name: 'items_count')
  int get itemsCount;
  @override
  List<OrderItem> get items;
  @override
  @JsonKey(name: 'shipping_address')
  Map<String, dynamic>? get shippingAddress;
  @override
  @JsonKey(name: 'status_history')
  List<OrderStatusHistory> get statusHistory;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_slug')
  String? get productSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_image')
  String? get productThumbnail => throw _privateConstructorUsedError;
  @JsonKey(name: 'variant_size')
  String? get variantSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'variant_color')
  String? get variantColor => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  String get total => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_slug') String? productSlug,
      @JsonKey(name: 'product_image') String? productThumbnail,
      @JsonKey(name: 'variant_size') String? variantSize,
      @JsonKey(name: 'variant_color') String? variantColor,
      int quantity,
      @JsonKey(name: 'unit_price') String price,
      @JsonKey(name: 'total_price') String total});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? productSlug = freezed,
    Object? productThumbnail = freezed,
    Object? variantSize = freezed,
    Object? variantColor = freezed,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSlug: freezed == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      productThumbnail: freezed == productThumbnail
          ? _value.productThumbnail
          : productThumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      variantSize: freezed == variantSize
          ? _value.variantSize
          : variantSize // ignore: cast_nullable_to_non_nullable
              as String?,
      variantColor: freezed == variantColor
          ? _value.variantColor
          : variantColor // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_slug') String? productSlug,
      @JsonKey(name: 'product_image') String? productThumbnail,
      @JsonKey(name: 'variant_size') String? variantSize,
      @JsonKey(name: 'variant_color') String? variantColor,
      int quantity,
      @JsonKey(name: 'unit_price') String price,
      @JsonKey(name: 'total_price') String total});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? productSlug = freezed,
    Object? productThumbnail = freezed,
    Object? variantSize = freezed,
    Object? variantColor = freezed,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
  }) {
    return _then(_$OrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSlug: freezed == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      productThumbnail: freezed == productThumbnail
          ? _value.productThumbnail
          : productThumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      variantSize: freezed == variantSize
          ? _value.variantSize
          : variantSize // ignore: cast_nullable_to_non_nullable
              as String?,
      variantColor: freezed == variantColor
          ? _value.variantColor
          : variantColor // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl(
      {required this.id,
      @JsonKey(name: 'product_name') this.productName = '',
      @JsonKey(name: 'product_slug') this.productSlug,
      @JsonKey(name: 'product_image') this.productThumbnail,
      @JsonKey(name: 'variant_size') this.variantSize,
      @JsonKey(name: 'variant_color') this.variantColor,
      this.quantity = 1,
      @JsonKey(name: 'unit_price') this.price = '0.00',
      @JsonKey(name: 'total_price') this.total = '0.00'});

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'product_slug')
  final String? productSlug;
  @override
  @JsonKey(name: 'product_image')
  final String? productThumbnail;
  @override
  @JsonKey(name: 'variant_size')
  final String? variantSize;
  @override
  @JsonKey(name: 'variant_color')
  final String? variantColor;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey(name: 'unit_price')
  final String price;
  @override
  @JsonKey(name: 'total_price')
  final String total;

  @override
  String toString() {
    return 'OrderItem(id: $id, productName: $productName, productSlug: $productSlug, productThumbnail: $productThumbnail, variantSize: $variantSize, variantColor: $variantColor, quantity: $quantity, price: $price, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSlug, productSlug) ||
                other.productSlug == productSlug) &&
            (identical(other.productThumbnail, productThumbnail) ||
                other.productThumbnail == productThumbnail) &&
            (identical(other.variantSize, variantSize) ||
                other.variantSize == variantSize) &&
            (identical(other.variantColor, variantColor) ||
                other.variantColor == variantColor) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, productName, productSlug,
      productThumbnail, variantSize, variantColor, quantity, price, total);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
      {required final String id,
      @JsonKey(name: 'product_name') final String productName,
      @JsonKey(name: 'product_slug') final String? productSlug,
      @JsonKey(name: 'product_image') final String? productThumbnail,
      @JsonKey(name: 'variant_size') final String? variantSize,
      @JsonKey(name: 'variant_color') final String? variantColor,
      final int quantity,
      @JsonKey(name: 'unit_price') final String price,
      @JsonKey(name: 'total_price') final String total}) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'product_slug')
  String? get productSlug;
  @override
  @JsonKey(name: 'product_image')
  String? get productThumbnail;
  @override
  @JsonKey(name: 'variant_size')
  String? get variantSize;
  @override
  @JsonKey(name: 'variant_color')
  String? get variantColor;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price')
  String get price;
  @override
  @JsonKey(name: 'total_price')
  String get total;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) {
  return _OrderStatusHistory.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusHistory {
  String get status => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusHistoryCopyWith<OrderStatusHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusHistoryCopyWith<$Res> {
  factory $OrderStatusHistoryCopyWith(
          OrderStatusHistory value, $Res Function(OrderStatusHistory) then) =
      _$OrderStatusHistoryCopyWithImpl<$Res, OrderStatusHistory>;
  @useResult
  $Res call(
      {String status,
      String? note,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$OrderStatusHistoryCopyWithImpl<$Res, $Val extends OrderStatusHistory>
    implements $OrderStatusHistoryCopyWith<$Res> {
  _$OrderStatusHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStatusHistoryImplCopyWith<$Res>
    implements $OrderStatusHistoryCopyWith<$Res> {
  factory _$$OrderStatusHistoryImplCopyWith(_$OrderStatusHistoryImpl value,
          $Res Function(_$OrderStatusHistoryImpl) then) =
      __$$OrderStatusHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String? note,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$OrderStatusHistoryImplCopyWithImpl<$Res>
    extends _$OrderStatusHistoryCopyWithImpl<$Res, _$OrderStatusHistoryImpl>
    implements _$$OrderStatusHistoryImplCopyWith<$Res> {
  __$$OrderStatusHistoryImplCopyWithImpl(_$OrderStatusHistoryImpl _value,
      $Res Function(_$OrderStatusHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$OrderStatusHistoryImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusHistoryImpl implements _OrderStatusHistory {
  const _$OrderStatusHistoryImpl(
      {required this.status,
      this.note,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$OrderStatusHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusHistoryImplFromJson(json);

  @override
  final String status;
  @override
  final String? note;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'OrderStatusHistory(status: $status, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusHistoryImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, note, createdAt);

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      __$$OrderStatusHistoryImplCopyWithImpl<_$OrderStatusHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusHistoryImplToJson(
      this,
    );
  }
}

abstract class _OrderStatusHistory implements OrderStatusHistory {
  const factory _OrderStatusHistory(
          {required final String status,
          final String? note,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$OrderStatusHistoryImpl;

  factory _OrderStatusHistory.fromJson(Map<String, dynamic> json) =
      _$OrderStatusHistoryImpl.fromJson;

  @override
  String get status;
  @override
  String? get note;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
