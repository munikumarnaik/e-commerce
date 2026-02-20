import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    @JsonKey(name: 'address_type') @Default('HOME') String addressType,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @Default('') String phone,
    @JsonKey(name: 'address_line1') @Default('') String addressLine1,
    @JsonKey(name: 'address_line2') String? addressLine2,
    @Default('') String city,
    @Default('') String state,
    @Default('India') String country,
    @JsonKey(name: 'postal_code') @Default('') String postalCode,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
