import 'dart:convert';
import 'package:frontend_hamalatulquran/models/histori_model.dart';
import 'package:frontend_hamalatulquran/models/target_hafalan_model.dart';
import 'package:frontend_hamalatulquran/models/user_model.dart';
import 'package:frontend_hamalatulquran/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';

import '../utils/util.dart';

class ApiService {
  static String baseUrl = "http://10.0.2.2:8000/api";
  static const requestTimeout = Duration(seconds: 5);

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
  Future<ProfileModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString("user_data");

    if (userJson == null || userJson.length < 3) {
      throw Exception("⚠ Data pengguna tidak ditemukan!");
    }

    final userMap = jsonDecode(userJson);
    final user = UserModel.fromJson(userMap);

    final int userId = user.id;
    final String role = user.role;
    final String token = user.token;

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
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 5));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Profil berhasil diambil!");

        final profileData = body['data'];
        final fotoProfilRaw = profileData["foto_profil"];
        profileData["foto_profil"] =
            (fotoProfilRaw != null && fotoProfilRaw is String)
                ? Utils.fixLocalhostURL(fotoProfilRaw)
                : "";

        return ProfileModel.fromJson(profileData);
      } else if (response.statusCode == 401) {
        throw Exception("⚠ Sesi habis, silakan login ulang.");
      } else {
        throw Exception(body["message"] ?? "❌ User tidak ditemukan");
      }
    } catch (e) {
      if (e is http.ClientException) {
        print("📡 ClientException: ${e.message}");
      }
      print("🚨 Error: $e");
      throw Exception("❌ Gagal mengambil profil: $e");
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
        throw Exception(
            "Gagal mengambil data santri - status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Get Santri by Id
  static Future<Santri> fetchSantribyId(int id) async {
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
      final response =
          await http.get(Uri.parse('$baseUrl/santri/jumlah-aktif'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['jumlah'];
      } else {
        throw Exception(
            "❌ Gagal fetch data! Status code: ${response.statusCode}");
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

  static Future<Map<String, dynamic>> getLaporanDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/nilai-santri/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final targetsRaw = data['targets'] as List;
      print("🚨 RAW TARGET JSON: $targetsRaw");
      final murojaahRaw = data['murojaah'] as List;
      print("🚨 RAW MUROJAAH JSON: $murojaahRaw");

      final santri = Santri.fromJson(data['santri']);
      final targets = (data['targets'] as List)
          .map((json) => TargetHafalan.fromJson(json))
          .toList();
      final murojaah = (data['murojaah'] as List)
          .map((json) => Histori.fromJson(json))
          .toList();

      print("🔥 targets data: $targets");
      print("🔥 murojaah data: $murojaah");

      return {
        'santri': santri,
        'targets': targets,
        'murojaah': murojaah,
      };
    } else {
      throw Exception('Gagal ambil data laporan santri');
    }
  }

  // Get Pengajar
  static Future<List<Pengajar>> fetchPengajar() async {
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
