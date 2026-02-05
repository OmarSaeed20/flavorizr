class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataParser, {
    String? keyData,
  }) {
    final data = json[keyData ?? 'data'] as Map<String, dynamic>?;
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: data != null ? dataParser(data) : null,
      message: json['message'] as String?,
      statusCode: json['status_code'] as int?,
    );
  }

  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;
}
