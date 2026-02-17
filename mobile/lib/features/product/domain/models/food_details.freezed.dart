// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodDetails _$FoodDetailsFromJson(Map<String, dynamic> json) {
  return _FoodDetails.fromJson(json);
}

/// @nodoc
mixin _$FoodDetails {
  @JsonKey(name: 'food_type')
  String? get foodType => throw _privateConstructorUsedError;
  @JsonKey(name: 'cuisine_type')
  String? get cuisineType => throw _privateConstructorUsedError;
  @JsonKey(name: 'spice_level')
  int get spiceLevel => throw _privateConstructorUsedError;
  String? get calories => throw _privateConstructorUsedError;
  String? get protein => throw _privateConstructorUsedError;
  String? get carbs => throw _privateConstructorUsedError;
  String? get fat => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_size')
  String? get servingSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparation_time')
  int? get preparationTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_gluten')
  bool get containsGluten => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_dairy')
  bool get containsDairy => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_nuts')
  bool get containsNuts => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_perishable')
  bool get isPerishable => throw _privateConstructorUsedError;

  /// Serializes this FoodDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodDetailsCopyWith<FoodDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodDetailsCopyWith<$Res> {
  factory $FoodDetailsCopyWith(
          FoodDetails value, $Res Function(FoodDetails) then) =
      _$FoodDetailsCopyWithImpl<$Res, FoodDetails>;
  @useResult
  $Res call(
      {@JsonKey(name: 'food_type') String? foodType,
      @JsonKey(name: 'cuisine_type') String? cuisineType,
      @JsonKey(name: 'spice_level') int spiceLevel,
      String? calories,
      String? protein,
      String? carbs,
      String? fat,
      @JsonKey(name: 'serving_size') String? servingSize,
      @JsonKey(name: 'preparation_time') int? preparationTime,
      @JsonKey(name: 'contains_gluten') bool containsGluten,
      @JsonKey(name: 'contains_dairy') bool containsDairy,
      @JsonKey(name: 'contains_nuts') bool containsNuts,
      @JsonKey(name: 'is_perishable') bool isPerishable});
}

/// @nodoc
class _$FoodDetailsCopyWithImpl<$Res, $Val extends FoodDetails>
    implements $FoodDetailsCopyWith<$Res> {
  _$FoodDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodType = freezed,
    Object? cuisineType = freezed,
    Object? spiceLevel = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
    Object? servingSize = freezed,
    Object? preparationTime = freezed,
    Object? containsGluten = null,
    Object? containsDairy = null,
    Object? containsNuts = null,
    Object? isPerishable = null,
  }) {
    return _then(_value.copyWith(
      foodType: freezed == foodType
          ? _value.foodType
          : foodType // ignore: cast_nullable_to_non_nullable
              as String?,
      cuisineType: freezed == cuisineType
          ? _value.cuisineType
          : cuisineType // ignore: cast_nullable_to_non_nullable
              as String?,
      spiceLevel: null == spiceLevel
          ? _value.spiceLevel
          : spiceLevel // ignore: cast_nullable_to_non_nullable
              as int,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as String?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as String?,
      carbs: freezed == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as String?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as String?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      preparationTime: freezed == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int?,
      containsGluten: null == containsGluten
          ? _value.containsGluten
          : containsGluten // ignore: cast_nullable_to_non_nullable
              as bool,
      containsDairy: null == containsDairy
          ? _value.containsDairy
          : containsDairy // ignore: cast_nullable_to_non_nullable
              as bool,
      containsNuts: null == containsNuts
          ? _value.containsNuts
          : containsNuts // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerishable: null == isPerishable
          ? _value.isPerishable
          : isPerishable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodDetailsImplCopyWith<$Res>
    implements $FoodDetailsCopyWith<$Res> {
  factory _$$FoodDetailsImplCopyWith(
          _$FoodDetailsImpl value, $Res Function(_$FoodDetailsImpl) then) =
      __$$FoodDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'food_type') String? foodType,
      @JsonKey(name: 'cuisine_type') String? cuisineType,
      @JsonKey(name: 'spice_level') int spiceLevel,
      String? calories,
      String? protein,
      String? carbs,
      String? fat,
      @JsonKey(name: 'serving_size') String? servingSize,
      @JsonKey(name: 'preparation_time') int? preparationTime,
      @JsonKey(name: 'contains_gluten') bool containsGluten,
      @JsonKey(name: 'contains_dairy') bool containsDairy,
      @JsonKey(name: 'contains_nuts') bool containsNuts,
      @JsonKey(name: 'is_perishable') bool isPerishable});
}

/// @nodoc
class __$$FoodDetailsImplCopyWithImpl<$Res>
    extends _$FoodDetailsCopyWithImpl<$Res, _$FoodDetailsImpl>
    implements _$$FoodDetailsImplCopyWith<$Res> {
  __$$FoodDetailsImplCopyWithImpl(
      _$FoodDetailsImpl _value, $Res Function(_$FoodDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodType = freezed,
    Object? cuisineType = freezed,
    Object? spiceLevel = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
    Object? servingSize = freezed,
    Object? preparationTime = freezed,
    Object? containsGluten = null,
    Object? containsDairy = null,
    Object? containsNuts = null,
    Object? isPerishable = null,
  }) {
    return _then(_$FoodDetailsImpl(
      foodType: freezed == foodType
          ? _value.foodType
          : foodType // ignore: cast_nullable_to_non_nullable
              as String?,
      cuisineType: freezed == cuisineType
          ? _value.cuisineType
          : cuisineType // ignore: cast_nullable_to_non_nullable
              as String?,
      spiceLevel: null == spiceLevel
          ? _value.spiceLevel
          : spiceLevel // ignore: cast_nullable_to_non_nullable
              as int,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as String?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as String?,
      carbs: freezed == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as String?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as String?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      preparationTime: freezed == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int?,
      containsGluten: null == containsGluten
          ? _value.containsGluten
          : containsGluten // ignore: cast_nullable_to_non_nullable
              as bool,
      containsDairy: null == containsDairy
          ? _value.containsDairy
          : containsDairy // ignore: cast_nullable_to_non_nullable
              as bool,
      containsNuts: null == containsNuts
          ? _value.containsNuts
          : containsNuts // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerishable: null == isPerishable
          ? _value.isPerishable
          : isPerishable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodDetailsImpl implements _FoodDetails {
  const _$FoodDetailsImpl(
      {@JsonKey(name: 'food_type') this.foodType,
      @JsonKey(name: 'cuisine_type') this.cuisineType,
      @JsonKey(name: 'spice_level') this.spiceLevel = 0,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      @JsonKey(name: 'serving_size') this.servingSize,
      @JsonKey(name: 'preparation_time') this.preparationTime,
      @JsonKey(name: 'contains_gluten') this.containsGluten = false,
      @JsonKey(name: 'contains_dairy') this.containsDairy = false,
      @JsonKey(name: 'contains_nuts') this.containsNuts = false,
      @JsonKey(name: 'is_perishable') this.isPerishable = false});

  factory _$FoodDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodDetailsImplFromJson(json);

  @override
  @JsonKey(name: 'food_type')
  final String? foodType;
  @override
  @JsonKey(name: 'cuisine_type')
  final String? cuisineType;
  @override
  @JsonKey(name: 'spice_level')
  final int spiceLevel;
  @override
  final String? calories;
  @override
  final String? protein;
  @override
  final String? carbs;
  @override
  final String? fat;
  @override
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @override
  @JsonKey(name: 'preparation_time')
  final int? preparationTime;
  @override
  @JsonKey(name: 'contains_gluten')
  final bool containsGluten;
  @override
  @JsonKey(name: 'contains_dairy')
  final bool containsDairy;
  @override
  @JsonKey(name: 'contains_nuts')
  final bool containsNuts;
  @override
  @JsonKey(name: 'is_perishable')
  final bool isPerishable;

  @override
  String toString() {
    return 'FoodDetails(foodType: $foodType, cuisineType: $cuisineType, spiceLevel: $spiceLevel, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, servingSize: $servingSize, preparationTime: $preparationTime, containsGluten: $containsGluten, containsDairy: $containsDairy, containsNuts: $containsNuts, isPerishable: $isPerishable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodDetailsImpl &&
            (identical(other.foodType, foodType) ||
                other.foodType == foodType) &&
            (identical(other.cuisineType, cuisineType) ||
                other.cuisineType == cuisineType) &&
            (identical(other.spiceLevel, spiceLevel) ||
                other.spiceLevel == spiceLevel) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.containsGluten, containsGluten) ||
                other.containsGluten == containsGluten) &&
            (identical(other.containsDairy, containsDairy) ||
                other.containsDairy == containsDairy) &&
            (identical(other.containsNuts, containsNuts) ||
                other.containsNuts == containsNuts) &&
            (identical(other.isPerishable, isPerishable) ||
                other.isPerishable == isPerishable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      foodType,
      cuisineType,
      spiceLevel,
      calories,
      protein,
      carbs,
      fat,
      servingSize,
      preparationTime,
      containsGluten,
      containsDairy,
      containsNuts,
      isPerishable);

  /// Create a copy of FoodDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodDetailsImplCopyWith<_$FoodDetailsImpl> get copyWith =>
      __$$FoodDetailsImplCopyWithImpl<_$FoodDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodDetailsImplToJson(
      this,
    );
  }
}

abstract class _FoodDetails implements FoodDetails {
  const factory _FoodDetails(
          {@JsonKey(name: 'food_type') final String? foodType,
          @JsonKey(name: 'cuisine_type') final String? cuisineType,
          @JsonKey(name: 'spice_level') final int spiceLevel,
          final String? calories,
          final String? protein,
          final String? carbs,
          final String? fat,
          @JsonKey(name: 'serving_size') final String? servingSize,
          @JsonKey(name: 'preparation_time') final int? preparationTime,
          @JsonKey(name: 'contains_gluten') final bool containsGluten,
          @JsonKey(name: 'contains_dairy') final bool containsDairy,
          @JsonKey(name: 'contains_nuts') final bool containsNuts,
          @JsonKey(name: 'is_perishable') final bool isPerishable}) =
      _$FoodDetailsImpl;

  factory _FoodDetails.fromJson(Map<String, dynamic> json) =
      _$FoodDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'food_type')
  String? get foodType;
  @override
  @JsonKey(name: 'cuisine_type')
  String? get cuisineType;
  @override
  @JsonKey(name: 'spice_level')
  int get spiceLevel;
  @override
  String? get calories;
  @override
  String? get protein;
  @override
  String? get carbs;
  @override
  String? get fat;
  @override
  @JsonKey(name: 'serving_size')
  String? get servingSize;
  @override
  @JsonKey(name: 'preparation_time')
  int? get preparationTime;
  @override
  @JsonKey(name: 'contains_gluten')
  bool get containsGluten;
  @override
  @JsonKey(name: 'contains_dairy')
  bool get containsDairy;
  @override
  @JsonKey(name: 'contains_nuts')
  bool get containsNuts;
  @override
  @JsonKey(name: 'is_perishable')
  bool get isPerishable;

  /// Create a copy of FoodDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodDetailsImplCopyWith<_$FoodDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
