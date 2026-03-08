import 'package:basic_store_app/model/apiException.dart';
import 'package:basic_store_app/model/loginModel.dart';
import 'package:basic_store_app/model/registerModel.dart';
import 'package:basic_store_app/remote/constant.dart';
import 'package:basic_store_app/remote/dioConfig.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService._();
  static ApiService api = ApiService._();
  String authUrl = Constants.authBaseUrl;
  //1- Create account for user
  Future<RegisterModel> registerUser(RegisterModel user) async {
    Dio dio = Dioconfig.getDio(
      url: authUrl,
      header: {'Content-Type': 'application/json'},
    );
    try {
      Response response = await dio.post(
        Constants.registerEndPoint,
        data: user.toJson(),
      );
      return RegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleException(e);
    }
  }

  //2- login for user
  Future<LoginModel> login(LoginModel user) async {
    Dio dio = Dioconfig.getDio(url: authUrl);
    try {
      Response response = await dio.post(
        Constants.loginEndPoint,
        data: user.toJson(),
      );
      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleException(e);
    }
  }

  //Create handle of Exception response of API with Dio
  dynamic handleException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return ApiExceptionAuth(
        code: 0,
        message: "No Internet Connection. Please check your network.",
      );
    }
    if (e.response != null) {
      int statusCode = e.response!.statusCode ?? 0;
      if (statusCode >= 500) {
        return ApiExceptionAuth(
          code: statusCode,
          message: "Server error. Please try again later.",
        );
      } else if (statusCode == 409) {
        return ApiExceptionAuth(
          code: statusCode,
          message: "This email is already in use.",
        );
      } else if (statusCode == 401 || statusCode == 404) {
        return ApiExceptionAuth(
          code: statusCode,
          message: "Invalid email or password.",
        );
      } else {
        return ApiExceptionAuth(
          code: statusCode,
          message: "Something went wrong. Please try again later.",
        );
      }
    }
  }
}
