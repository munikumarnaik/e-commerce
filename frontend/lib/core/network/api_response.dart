class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'],
      message: json['message'] as String?,
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'] as Map)
          : null,
    );
  }
}
