class RegisterModel {
  String name;
  String email;
  String password;
  String? message;
  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    this.message,
  });
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      message: json['message'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
