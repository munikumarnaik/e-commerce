import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:8000/api/v1';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int maxRetries = 2;
}
