import 'dart:convert';
import 'package:frontend_hamalatulquran/models/user_model.dart';
import 'package:frontend_hamalatulquran/services/env.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String baseUrl = Environment.baseUrl;
  static const requestTimeout = Environment.requestTimeout;

  Future<Map<String, dynamic>> _fetchPost(Uri url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      final response = await http
          .post(
            url,
            headers: headers ?? {"Content-Type": "application/json"},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(requestTimeout);

      print("🚀 Response API: ${response.body}");

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        throw Exception(jsonResponse["message"] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  // 🔐 Login & Simpan User
  Future<String> loginAndSave(String identifier, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await _fetchPost(url, body: {
      "identifier": identifier,
      "password": password,
    });

    if (response["success"] != true) {
      throw Exception(response["message"] ?? "Login gagal, coba lagi.");
    }

    final userData = response["data"];
    final token = response["token"];

    // Gabung data dan token biar bisa diparse ke UserModel
    final user = UserModel.fromJson({
      ...(userData as Map<String, dynamic>),
      "token": token,
    });

    // Simpan ke SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "user_data",
        jsonEncode({
          "id": user.id,
          "nama": user.nama,
          "role": user.role,
          "foto_profil": user.fotoProfil,
          "jenis_kelamin": user.jenisKelamin,
          "token": user.token
        }));

    await prefs.setString("role", user.role);

    final savedUser = prefs.getString("user_data");
    if (savedUser != null) {
      print("✅ Data user: $savedUser");
    } else {
      print("❌ Gagal ambil data user dari SharedPreferences");
    }
    return user.role;
  }

  // 🔥 Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("✅ Logout berhasil!");
  }
}
