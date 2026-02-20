sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection. Please check your network.']);
}

class ServerException extends AppException {
  final int statusCode;
  const ServerException({required this.statusCode, required String message}) : super(message);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed. Please log in again.']);
}

class ValidationException extends AppException {
  final Map<String, dynamic> errors;
  const ValidationException({required this.errors, required String message}) : super(message);

  String get firstError {
    for (final entry in errors.entries) {
      if (entry.value is List && (entry.value as List).isNotEmpty) {
        return (entry.value as List).first.toString();
      }
      if (entry.value is String) {
        return entry.value as String;
      }
    }
    return message;
  }
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong. Please try again.']);
}
