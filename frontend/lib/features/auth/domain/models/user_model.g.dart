// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      role: json['role'] as String? ?? 'CUSTOMER',
      isVerified: json['is_verified'] as bool? ?? false,
      notificationEnabled: json['notification_enabled'] as bool? ?? true,
      emailNotificationEnabled:
          json['email_notification_enabled'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      lastLogin: json['last_login'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'profile_image': instance.profileImage,
      'date_of_birth': instance.dateOfBirth,
      'role': instance.role,
      'is_verified': instance.isVerified,
      'notification_enabled': instance.notificationEnabled,
      'email_notification_enabled': instance.emailNotificationEnabled,
      'created_at': instance.createdAt,
      'last_login': instance.lastLogin,
    };
