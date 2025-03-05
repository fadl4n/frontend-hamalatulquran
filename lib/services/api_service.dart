import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.0.192:8000/api"; // Ganti sesuai server

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final url = Uri.parse("$baseUrl/login");
    print("Mengirim request ke: $url");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"identifier": identifier, "password": password}),
          )
          .timeout(const Duration(seconds: 5));

      print("Response Status: ${response.statusCode}");
      print("RAW Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": jsonDecode(response.body)["message"] ??
              "Login gagal, periksa kembali data Anda"
        };
      }
    } catch (e) {
      print("Error saat login: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  // Function untuk Get Profile
  Future<Map<String, dynamic>> getProfile(String identifier) async {
    final url = Uri.parse("$baseUrl/profile/$identifier");
    print("Mengambil data profile dari: $url");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']; // Ambil data user
      } else {
        return {
          "error":
              jsonDecode(response.body)["message"] ?? "User tidak ditemukan"
        };
      }
    } catch (e) {
      print("Error saat mengambil profile: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }
}
