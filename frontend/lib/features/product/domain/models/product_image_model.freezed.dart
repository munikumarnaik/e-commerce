// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) {
  return _ProductImage.fromJson(json);
}

/// @nodoc
mixin _$ProductImage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'alt_text')
  String get altText => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;

  /// Serializes this ProductImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductImageCopyWith<ProductImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductImageCopyWith<$Res> {
  factory $ProductImageCopyWith(
          ProductImage value, $Res Function(ProductImage) then) =
      _$ProductImageCopyWithImpl<$Res, ProductImage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'alt_text') String altText,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class _$ProductImageCopyWithImpl<$Res, $Val extends ProductImage>
    implements $ProductImageCopyWith<$Res> {
  _$ProductImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? altText = null,
    Object? displayOrder = null,
    Object? isPrimary = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: null == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImageImplCopyWith<$Res>
    implements $ProductImageCopyWith<$Res> {
  factory _$$ProductImageImplCopyWith(
          _$ProductImageImpl value, $Res Function(_$ProductImageImpl) then) =
      __$$ProductImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'alt_text') String altText,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class __$$ProductImageImplCopyWithImpl<$Res>
    extends _$ProductImageCopyWithImpl<$Res, _$ProductImageImpl>
    implements _$$ProductImageImplCopyWith<$Res> {
  __$$ProductImageImplCopyWithImpl(
      _$ProductImageImpl _value, $Res Function(_$ProductImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? altText = null,
    Object? displayOrder = null,
    Object? isPrimary = null,
  }) {
    return _then(_$ProductImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: null == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImageImpl implements _ProductImage {
  const _$ProductImageImpl(
      {required this.id,
      @JsonKey(name: 'image_url') required this.imageUrl,
      @JsonKey(name: 'alt_text') this.altText = '',
      @JsonKey(name: 'display_order') this.displayOrder = 0,
      @JsonKey(name: 'is_primary') this.isPrimary = false});

  factory _$ProductImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'alt_text')
  final String altText;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @override
  String toString() {
    return 'ProductImage(id: $id, imageUrl: $imageUrl, altText: $altText, displayOrder: $displayOrder, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.altText, altText) || other.altText == altText) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, imageUrl, altText, displayOrder, isPrimary);

  /// Create a copy of ProductImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      __$$ProductImageImplCopyWithImpl<_$ProductImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImageImplToJson(
      this,
    );
  }
}

abstract class _ProductImage implements ProductImage {
  const factory _ProductImage(
      {required final String id,
      @JsonKey(name: 'image_url') required final String imageUrl,
      @JsonKey(name: 'alt_text') final String altText,
      @JsonKey(name: 'display_order') final int displayOrder,
      @JsonKey(name: 'is_primary') final bool isPrimary}) = _$ProductImageImpl;

  factory _ProductImage.fromJson(Map<String, dynamic> json) =
      _$ProductImageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'alt_text')
  String get altText;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;

  /// Create a copy of ProductImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
