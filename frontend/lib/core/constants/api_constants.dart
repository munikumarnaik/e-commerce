import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://e-commerce-23ff.onrender.com/api/v1';

  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;
  static const int maxRetries = 2;
}
