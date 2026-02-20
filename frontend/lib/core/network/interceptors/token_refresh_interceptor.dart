import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../api_endpoints.dart';
import '../api_exception.dart';

class TokenRefreshInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final void Function()? onForceLogout;

  // A separate Dio instance without auth interceptors to avoid infinite loop
  late final Dio _refreshDio;

  TokenRefreshInterceptor(
    this._dio,
    this._secureStorage, {
    this.onForceLogout,
  }) {
    _refreshDio = Dio(BaseOptions(
      baseUrl: _dio.options.baseUrl,
      connectTimeout: _dio.options.connectTimeout,
      receiveTimeout: _dio.options.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Don't try to refresh on the refresh endpoint itself
    if (err.requestOptions.path.endsWith(ApiEndpoints.tokenRefresh)) {
      await _secureStorage.clearTokens();
      onForceLogout?.call();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthException('Session expired. Please log in again.'),
        ),
      );
      return;
    }

    // Try to refresh the token
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      await _secureStorage.clearTokens();
      onForceLogout?.call();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthException(),
        ),
      );
      return;
    }

    try {
      final response = await _refreshDio.post(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      final data = response.data['data'] ?? response.data;
      final newAccess = data['access'] as String;
      final newRefresh = data['refresh'] as String?;

      await _secureStorage.saveAccessToken(newAccess);
      if (newRefresh != null) {
        await _secureStorage.saveRefreshToken(newRefresh);
      }

      // Retry the original request with the new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccess';

      final retryResponse = await _refreshDio.fetch(options);
      handler.resolve(retryResponse);
    } on DioException {
      await _secureStorage.clearTokens();
      onForceLogout?.call();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthException('Session expired. Please log in again.'),
        ),
      );
    }
  }
}
