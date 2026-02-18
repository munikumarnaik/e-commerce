// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodDetailsImpl _$$FoodDetailsImplFromJson(Map<String, dynamic> json) =>
    _$FoodDetailsImpl(
      foodType: json['food_type'] as String?,
      cuisineType: json['cuisine_type'] as String?,
      spiceLevel: (json['spice_level'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt(),
      protein: json['protein'] as String?,
      carbs: json['carbs'] as String?,
      fat: json['fat'] as String?,
      servingSize: json['serving_size'] as String?,
      preparationTime: (json['preparation_time'] as num?)?.toInt(),
      containsGluten: json['contains_gluten'] as bool? ?? false,
      containsDairy: json['contains_dairy'] as bool? ?? false,
      containsNuts: json['contains_nuts'] as bool? ?? false,
      isPerishable: json['is_perishable'] as bool? ?? false,
    );

Map<String, dynamic> _$$FoodDetailsImplToJson(_$FoodDetailsImpl instance) =>
    <String, dynamic>{
      'food_type': instance.foodType,
      'cuisine_type': instance.cuisineType,
      'spice_level': instance.spiceLevel,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'serving_size': instance.servingSize,
      'preparation_time': instance.preparationTime,
      'contains_gluten': instance.containsGluten,
      'contains_dairy': instance.containsDairy,
      'contains_nuts': instance.containsNuts,
      'is_perishable': instance.isPerishable,
    };
