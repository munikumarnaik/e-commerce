import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_details.freezed.dart';
part 'food_details.g.dart';

@freezed
class FoodDetails with _$FoodDetails {
  const factory FoodDetails({
    @JsonKey(name: 'food_type') String? foodType,
    @JsonKey(name: 'cuisine_type') String? cuisineType,
    @JsonKey(name: 'spice_level') @Default(0) int spiceLevel,
    int? calories,
    String? protein,
    String? carbs,
    String? fat,
    @JsonKey(name: 'serving_size') String? servingSize,
    @JsonKey(name: 'preparation_time') int? preparationTime,
    @JsonKey(name: 'contains_gluten') @Default(false) bool containsGluten,
    @JsonKey(name: 'contains_dairy') @Default(false) bool containsDairy,
    @JsonKey(name: 'contains_nuts') @Default(false) bool containsNuts,
    @JsonKey(name: 'is_perishable') @Default(false) bool isPerishable,
  }) = _FoodDetails;

  factory FoodDetails.fromJson(Map<String, dynamic> json) =>
      _$FoodDetailsFromJson(json);
}
