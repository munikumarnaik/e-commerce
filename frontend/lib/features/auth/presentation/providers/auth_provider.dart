import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../shared/providers/storage_providers.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/models/auth_tokens.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _secureStorage;

  AuthNotifier(this._repository, this._secureStorage)
      : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    try {
      final user = await _repository.getUserProfile();
      final refreshToken = await _secureStorage.getRefreshToken();
      state = AuthState.authenticated(
        user: user,
        tokens: AuthTokens(access: accessToken, refresh: refreshToken ?? ''),
      );
    } on AppException {
      // Token might be expired — try refresh
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        await _secureStorage.clearTokens();
        state = const AuthState.unauthenticated();
        return;
      }

      try {
        final newTokens = await _repository.refreshToken(refreshToken);
        await _secureStorage.saveAccessToken(newTokens.access);
        await _secureStorage.saveRefreshToken(newTokens.refresh);

        final user = await _repository.getUserProfile();
        state = AuthState.authenticated(user: user, tokens: newTokens);
      } catch (_) {
        await _secureStorage.clearTokens();
        state = const AuthState.unauthenticated();
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await _repository.login(
        email: email,
        password: password,
      );

      await _secureStorage.saveAccessToken(result.tokens.access);
      await _secureStorage.saveRefreshToken(result.tokens.refresh);
      await _secureStorage.saveUser(jsonEncode(result.user.toJson()));

      state = AuthState.authenticated(
        user: result.user,
        tokens: result.tokens,
      );
    } on ValidationException catch (e) {
      state = AuthState.error(e.firstError);
    } on AppException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Login failed. Please try again.');
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await _repository.register(
        email: email,
        username: username,
        password: password,
        passwordConfirm: passwordConfirm,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      await _secureStorage.saveAccessToken(result.tokens.access);
      await _secureStorage.saveRefreshToken(result.tokens.refresh);
      await _secureStorage.saveUser(jsonEncode(result.user.toJson()));

      state = AuthState.authenticated(
        user: result.user,
        tokens: result.tokens,
      );
    } on ValidationException catch (e) {
      state = AuthState.error(e.firstError);
    } on AppException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Registration failed. Please try again.');
    }
  }

  /// Register FCM token with the backend. Call after login/register.
  Future<void> registerFcmToken(String token) async {
    try {
      await _repository.updateFcmToken(token);
    } catch (_) {
      // Best-effort — ignore errors
    }
  }

  Future<void> logout() async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      await _repository.logout(currentState.tokens.refresh);
    }
    await _secureStorage.clearAll();
    state = const AuthState.unauthenticated();
  }

  Future<void> requestPasswordReset(String email) async {
    await _repository.requestPasswordReset(email);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(repository, secureStorage);
});
