import 'package:freezed_annotation/freezed_annotation.dart';

part 'clothing_details.freezed.dart';
part 'clothing_details.g.dart';

@freezed
class ClothingDetails with _$ClothingDetails {
  const factory ClothingDetails({
    String? gender,
    @JsonKey(name: 'clothing_type') String? clothingType,
    String? material,
    String? fabric,
    @JsonKey(name: 'care_instructions') String? careInstructions,
    @JsonKey(name: 'fit_type') String? fitType,
    String? pattern,
    String? length,
    String? width,
    String? season,
  }) = _ClothingDetails;

  factory ClothingDetails.fromJson(Map<String, dynamic> json) =>
      _$ClothingDetailsFromJson(json);
}
