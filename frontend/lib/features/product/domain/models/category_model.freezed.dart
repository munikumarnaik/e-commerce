// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return _SubCategory.fromJson(json);
}

/// @nodoc
mixin _$SubCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_count')
  int get productCount => throw _privateConstructorUsedError;

  /// Serializes this SubCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubCategoryCopyWith<SubCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubCategoryCopyWith<$Res> {
  factory $SubCategoryCopyWith(
          SubCategory value, $Res Function(SubCategory) then) =
      _$SubCategoryCopyWithImpl<$Res, SubCategory>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'product_count') int productCount});
}

/// @nodoc
class _$SubCategoryCopyWithImpl<$Res, $Val extends SubCategory>
    implements $SubCategoryCopyWith<$Res> {
  _$SubCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? productCount = null,
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
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubCategoryImplCopyWith<$Res>
    implements $SubCategoryCopyWith<$Res> {
  factory _$$SubCategoryImplCopyWith(
          _$SubCategoryImpl value, $Res Function(_$SubCategoryImpl) then) =
      __$$SubCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'product_count') int productCount});
}

/// @nodoc
class __$$SubCategoryImplCopyWithImpl<$Res>
    extends _$SubCategoryCopyWithImpl<$Res, _$SubCategoryImpl>
    implements _$$SubCategoryImplCopyWith<$Res> {
  __$$SubCategoryImplCopyWithImpl(
      _$SubCategoryImpl _value, $Res Function(_$SubCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? productCount = null,
  }) {
    return _then(_$SubCategoryImpl(
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
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubCategoryImpl implements _SubCategory {
  const _$SubCategoryImpl(
      {required this.id,
      required this.name,
      required this.slug,
      @JsonKey(name: 'product_count') this.productCount = 0});

  factory _$SubCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  @JsonKey(name: 'product_count')
  final int productCount;

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, slug: $slug, productCount: $productCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug, productCount);

  /// Create a copy of SubCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubCategoryImplCopyWith<_$SubCategoryImpl> get copyWith =>
      __$$SubCategoryImplCopyWithImpl<_$SubCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubCategoryImplToJson(
      this,
    );
  }
}

abstract class _SubCategory implements SubCategory {
  const factory _SubCategory(
          {required final String id,
          required final String name,
          required final String slug,
          @JsonKey(name: 'product_count') final int productCount}) =
      _$SubCategoryImpl;

  factory _SubCategory.fromJson(Map<String, dynamic> json) =
      _$SubCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'product_count')
  int get productCount;

  /// Create a copy of SubCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubCategoryImplCopyWith<_$SubCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_type')
  String? get categoryType => throw _privateConstructorUsedError;
  String? get parent => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_count')
  int get productCount => throw _privateConstructorUsedError;
  List<SubCategory> get subcategories => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'category_type') String? categoryType,
      String? parent,
      String? image,
      String? icon,
      String? description,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'product_count') int productCount,
      List<SubCategory> subcategories});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? categoryType = freezed,
    Object? parent = freezed,
    Object? image = freezed,
    Object? icon = freezed,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? productCount = null,
    Object? subcategories = null,
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
      categoryType: freezed == categoryType
          ? _value.categoryType
          : categoryType // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      subcategories: null == subcategories
          ? _value.subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<SubCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      @JsonKey(name: 'category_type') String? categoryType,
      String? parent,
      String? image,
      String? icon,
      String? description,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'product_count') int productCount,
      List<SubCategory> subcategories});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? categoryType = freezed,
    Object? parent = freezed,
    Object? image = freezed,
    Object? icon = freezed,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? productCount = null,
    Object? subcategories = null,
  }) {
    return _then(_$CategoryImpl(
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
      categoryType: freezed == categoryType
          ? _value.categoryType
          : categoryType // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      subcategories: null == subcategories
          ? _value._subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<SubCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {required this.id,
      required this.name,
      required this.slug,
      @JsonKey(name: 'category_type') this.categoryType,
      this.parent,
      this.image,
      this.icon,
      this.description,
      @JsonKey(name: 'display_order') this.displayOrder = 0,
      @JsonKey(name: 'product_count') this.productCount = 0,
      final List<SubCategory> subcategories = const []})
      : _subcategories = subcategories;

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  @JsonKey(name: 'category_type')
  final String? categoryType;
  @override
  final String? parent;
  @override
  final String? image;
  @override
  final String? icon;
  @override
  final String? description;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'product_count')
  final int productCount;
  final List<SubCategory> _subcategories;
  @override
  @JsonKey()
  List<SubCategory> get subcategories {
    if (_subcategories is EqualUnmodifiableListView) return _subcategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategories);
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, slug: $slug, categoryType: $categoryType, parent: $parent, image: $image, icon: $icon, description: $description, displayOrder: $displayOrder, productCount: $productCount, subcategories: $subcategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.categoryType, categoryType) ||
                other.categoryType == categoryType) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            const DeepCollectionEquality()
                .equals(other._subcategories, _subcategories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      categoryType,
      parent,
      image,
      icon,
      description,
      displayOrder,
      productCount,
      const DeepCollectionEquality().hash(_subcategories));

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(
      this,
    );
  }
}

abstract class _Category implements Category {
  const factory _Category(
      {required final String id,
      required final String name,
      required final String slug,
      @JsonKey(name: 'category_type') final String? categoryType,
      final String? parent,
      final String? image,
      final String? icon,
      final String? description,
      @JsonKey(name: 'display_order') final int displayOrder,
      @JsonKey(name: 'product_count') final int productCount,
      final List<SubCategory> subcategories}) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'category_type')
  String? get categoryType;
  @override
  String? get parent;
  @override
  String? get image;
  @override
  String? get icon;
  @override
  String? get description;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'product_count')
  int get productCount;
  @override
  List<SubCategory> get subcategories;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
