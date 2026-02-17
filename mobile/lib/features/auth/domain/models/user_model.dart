import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @Default('CUSTOMER') String role,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'notification_enabled') @Default(true) bool notificationEnabled,
    @JsonKey(name: 'email_notification_enabled') @Default(true) bool emailNotificationEnabled,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'last_login') String? lastLogin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
