import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel user;
  final String token;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      user: UserModel.fromJson(json['data']),
      token: json['token'],
    );
  }
}
