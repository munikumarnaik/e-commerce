import 'package:dio/dio.dart';
import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        exception = const NetworkException();
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 500;
        final data = err.response?.data;

        if (statusCode == 401) {
          // Let token_refresh_interceptor handle 401 first
          handler.next(err);
          return;
        }

        if (data is Map<String, dynamic>) {
          final message = data['message'] as String? ?? 'Request failed';
          final errors = data['errors'] as Map<String, dynamic>?;

          if (statusCode == 400 || statusCode == 422) {
            exception = ValidationException(
              errors: errors ?? {},
              message: message,
            );
          } else if (statusCode == 403) {
            exception = AuthException(message);
          } else {
            exception = ServerException(
              statusCode: statusCode,
              message: message,
            );
          }
        } else {
          exception = ServerException(
            statusCode: statusCode,
            message: 'Server error ($statusCode)',
          );
        }
        break;

      case DioExceptionType.cancel:
        handler.next(err);
        return;

      default:
        exception = const UnknownException();
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }
}
