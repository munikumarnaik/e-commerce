import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/auth_tokens.dart';
import '../../domain/models/user_model.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<({User user, AuthTokens tokens})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final body = response.data;
      final user = User.fromJson(body['data']['user']);
      final tokens = AuthTokens.fromJson(body['data']['tokens']);
      return (user: user, tokens: tokens);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<({User user, AuthTokens tokens})> register({
    required String email,
    required String username,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final data = {
        'email': email,
        'username': username,
        'password': password,
        'password_confirm': passwordConfirm,
        'first_name': firstName,
        'last_name': lastName,
      };
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await _dio.post(ApiEndpoints.register, data: data);
      final body = response.data;
      final user = User.fromJson(body['data']['user']);
      final tokens = AuthTokens.fromJson(body['data']['tokens']);
      return (user: user, tokens: tokens);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(ApiEndpoints.logout, data: {'refresh': refreshToken});
    } on DioException {
      // Ignore errors on logout — clear local state regardless
    }
  }

  Future<AuthTokens> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );
      final data = response.data['data'] ?? response.data;
      return AuthTokens.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getUserProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.userProfile);
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(ApiEndpoints.passwordReset, data: {'email': email});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      await _dio.post(ApiEndpoints.verifyEmail, data: {'token': token});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateFcmToken(String token) async {
    try {
      await _dio.post(ApiEndpoints.fcmToken, data: {'fcm_token': token});
    } on DioException {
      // Best-effort — ignore errors
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return const UnknownException();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});
