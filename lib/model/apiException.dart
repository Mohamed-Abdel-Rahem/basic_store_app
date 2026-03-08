class ApiExceptionAuth {
  int code;
  String message;

  ApiExceptionAuth({required this.code, required this.message});
  @override
  String toString() => message;
  factory ApiExceptionAuth.fromJson(Map<String, dynamic> json) {
    return ApiExceptionAuth(
      code: json['code'] ?? 0,
      message: json['message'] ?? 'Error',
    );
  }
}
