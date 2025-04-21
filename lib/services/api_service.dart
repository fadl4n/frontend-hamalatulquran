import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/login_model.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  static const requestTimeout = Duration(seconds: 5);

  // 🔥 Refactor fungsi fetch data dari API
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
        return {"error": jsonResponse["message"] ?? "Terjadi kesalahan"};
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  // 🔥 Login & Save User Data
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

    // gabung token ke dalam map biar bisa dibaca model
    final Map<String, dynamic> userJson = {
      ...userData,
      "token": token,
    };

    final user = User.fromJson(userJson);

    // simpen ke SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("user_data", [
      user.id.toString(), // -> 0
      user.role, // -> 1
      user.fotoProfil, // -> 2
      user.jenisKelaminStr, // -> 3
      user.token, // -> 4
    ]);

    print(
        "✅ Data ${prefs.getStringList("user_data")} berhasil disimpan ke SharedPreferences!");

    return user.role;
  }

  // 🔥 Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("✅ Logout berhasil!");
  }

  static String getDefaultAssetByRoleGender(String role, String gender) {
    if (role == "pengajar") {
      return gender == "Laki-laki"
          ? "assets/ustadz.png"
          : "assets/ustadzah.png";
    } else if (role == "santri") {
      return gender == "Laki-laki" ? "assets/ikhwan.png" : "assets/akhwat.png";
    }
    return "assets/user.png";
  }

  // 🔥 Get Profile Icon
  static Future<String> getProfileIcon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? userData = prefs.getStringList("user_data");

    String role = userData?.elementAtOrNull(1) ?? "pengajar";
    String? url = userData?.elementAtOrNull(2);
    String gender = userData?.elementAtOrNull(3) ?? "Laki-laki";

    String fixedUrl = Utils.fixLocalhostURL(url);

    if (fixedUrl.isEmpty || fixedUrl == "null") {
      return getDefaultAssetByRoleGender(role, gender);
    }

    return fixedUrl;
  }

  // 🔥 Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? userData = prefs.getStringList("user_data");

    if (userData == null || userData.length < 3) {
      throw Exception("⚠ Data pengguna tidak ditemukan!");
    }

    final String userId = userData[0];
    final String role = userData[1];
    final String token = userData[4];

    if (token.isEmpty) {
      throw Exception("⚠ Token tidak ditemukan, silakan login ulang.");
    }

    final url = Uri.parse("$baseUrl/profile/$role/$userId");

    print("🔗 Fetching profile from: $url");
    print("🔑 Token yang dikirim: $token");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 5));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Profil berhasil diambil!");

        final profileData = body['data'];
        profileData["foto_profil"] = profileData["foto_profil"] is String
            ? Utils.fixLocalhostURL(profileData["foto_profil"])
            : ""; // Kalau bukan String, pakai string kosong biar aman

        return profileData;
      } else if (response.statusCode == 401) {
        throw Exception("⚠ Sesi habis, silakan login ulang.");
      } else {
        throw Exception(body["message"] ?? "❌ User tidak ditemukan");
      }
    } catch (e) {
      print("🚨 Error: $e");
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  // Get Santri
  Future<List<Santri>> fetchSantri() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/santri"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        final List data = jsonResponse['data'];

        return data.map((json) {
          json['foto_santri'] =
              Utils.fixLocalhostURL(json['foto_santri']); // Fix URL
          return Santri.fromJson(json);
        }).toList();
      } else {
        throw Exception("Gagal mengambil data santri");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Get Santri by Id
  Future<Santri> fetchSantribyId(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/santri/$id"));
      print("Raw response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        final data = jsonResponse['data'];
        if (data == null) {
          throw Exception("Data santri tidak ditemukan.");
        }

        data['foto_santri'] = Utils.fixLocalhostURL(data['foto_santri']);
        return Santri.fromJson(data);
      } else {
        throw Exception(
            "Gagal mengambil data santri - status code: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 Error fetchSantribyId: $e");
      throw Exception("Error: $e");
    }
  }

  Future<int> countSantriAktif() async {
    try {
    final response = await http.get(Uri.parse('$baseUrl/santri/jumlah-aktif'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data ['jumlah'];
      } else {
        throw Exception("❌ Gagal fetch data! Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ Error countSantriAktif: $e");
    }
  }

  Future<List<Santri>> fetchSantriByKelas(int idKelas) async {
    final response =
        await http.get(Uri.parse('$baseUrl/santri/by-kelas/$idKelas'));
    print("🛰 Status Code: ${response.statusCode}");
    print("📦 Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == false) {
        // Kelas kosong
        return [];
      }

      return (jsonData['data'] as List).map((e) => Santri.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data santri");
    }
  }

  // Get Pengajar
  Future<List<Pengajar>> fetchPengajar() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/pengajar"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        final List data = jsonResponse['data'];

        return data.map((json) {
          json['foto_pengajar'] =
              Utils.fixLocalhostURL(json['foto_pengajar']); // Fix URL
          return Pengajar.fromJson(json);
        }).toList();
      } else {
        throw Exception("Gagal mengambil data pengajar");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Pengajar> fetchPengajarbyId(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/pengajar/$id"));
      print("Raw response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        final data = jsonResponse['data'];
        if (data == null) {
          throw Exception("Data Pengajar tidak ditemukan.");
        }

        data['foto_pengajar'] = Utils.fixLocalhostURL(data['foto_pengajar']);
        return Pengajar.fromJson(data);
      } else {
        throw Exception(
            "Gagal mengambil data pengajar - status code: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 Error fetchPengajarbyId: $e");
      throw Exception("Error: $e");
    }
  }

  Future<List<Kelas>> fetchKelas() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/kelas"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("API Response: $jsonResponse");

        final List data = jsonResponse['data'];

        // Convert List JSON ke List<Kelas>
        return data.map((item) => Kelas.fromJson(item)).toList();
      } else {
        throw Exception("Gagal mengambil data Kelas");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
