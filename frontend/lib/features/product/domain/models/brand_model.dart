import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@freezed
class Brand with _$Brand {
  const factory Brand({
    required String id,
    required String name,
    required String slug,
    String? logo,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
