import 'package:dio/dio.dart';

class Dioconfig {
  Dioconfig._();
  static Dio? _dio;
  static Dio getDio({String url = '', Map<String, dynamic>? header}) {
    if (_dio == null) {
      _dio = Dio();

      _dio!.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          requestHeader: true,
          requestBody: true,
        ),
      );
    }
    _dio!.options.baseUrl = url;
    _dio!.options.headers = header;
    _dio!.options.connectTimeout = Duration(seconds: 5);
    _dio!.options.receiveTimeout = Duration(seconds: 5);
    return _dio!;
  }
}
