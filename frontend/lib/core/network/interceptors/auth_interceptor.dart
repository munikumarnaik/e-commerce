import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints
    final publicPaths = [
      '/auth/login/',
      '/auth/register/',
      '/auth/token/refresh/',
      '/auth/verify-email/',
      '/auth/password/reset/',
      '/auth/password/reset/confirm/',
    ];

    final isPublic = publicPaths.any((p) => options.path.endsWith(p));
    if (!isPublic) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}
