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

class ApiexceptionWeather {
  int cod;
  String message;
  @override
  String toString() => message;

  ApiexceptionWeather({required this.cod, required this.message});
  factory ApiexceptionWeather.fromJson(Map<String, dynamic> json) {
    return ApiexceptionWeather(
      cod: json['cod'] is String ? int.parse(json['cod']) : (json['cod'] ?? 0),
      message: json['message'] ?? 'Error',
    );
  }
}
