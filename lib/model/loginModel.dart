class LoginModel {
  String email;
  String password;
  String? message;
  String? accessToken;
  LoginModel({
    required this.email,
    required this.password,
    this.accessToken,
    this.message,
  });
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      message: json['message'] ?? '',
      accessToken: json['access_token'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
