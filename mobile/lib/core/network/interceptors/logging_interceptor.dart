import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─── API Request ───');
      debugPrint('│ ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└───────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─── API Response ───');
      debugPrint('│ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
      debugPrint('└────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─── API Error ───');
      debugPrint('│ ${err.response?.statusCode ?? 'N/A'} ${err.requestOptions.method} ${err.requestOptions.uri}');
      debugPrint('│ ${err.message}');
      if (err.response?.data != null) {
        debugPrint('│ ${err.response?.data}');
      }
      debugPrint('└──────────────────');
    }
    handler.next(err);
  }
}
