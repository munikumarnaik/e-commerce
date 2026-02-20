// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClothingDetailsImpl _$$ClothingDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$ClothingDetailsImpl(
      gender: json['gender'] as String?,
      clothingType: json['clothing_type'] as String?,
      material: json['material'] as String?,
      fabric: json['fabric'] as String?,
      careInstructions: json['care_instructions'] as String?,
      fitType: json['fit_type'] as String?,
      pattern: json['pattern'] as String?,
      length: json['length'] as String?,
      width: json['width'] as String?,
      season: json['season'] as String?,
    );

Map<String, dynamic> _$$ClothingDetailsImplToJson(
        _$ClothingDetailsImpl instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'clothing_type': instance.clothingType,
      'material': instance.material,
      'fabric': instance.fabric,
      'care_instructions': instance.careInstructions,
      'fit_type': instance.fitType,
      'pattern': instance.pattern,
      'length': instance.length,
      'width': instance.width,
      'season': instance.season,
    };
