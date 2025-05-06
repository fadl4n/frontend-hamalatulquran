import 'dart:convert';
import 'package:frontend_hamalatulquran/models/target_by_group_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_hamalatulquran/models/target_model.dart';

class TargetService {
  static String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<TargetHafalan>> fetchAllTarget() async {
    final response = await http.get(Uri.parse('$baseUrl/target'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => TargetHafalan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal ambil data target hafalan');
    }
  }

  Future<TargetHafalan> getById(int idTarget) async {
    final response = await http.get(Uri.parse('$baseUrl/target/id/$idTarget'));
    final data = jsonDecode(response.body)['data'];
    return TargetHafalan.fromJson(data);
  }

  static Future<List<TargetByGroup>> fetchTargetBySantriGroup(
      String idSantri, String idGroup) async {
    print("Fetching: $baseUrl/target/$idSantri/$idGroup");
    final response =
        await http.get(Uri.parse('$baseUrl/target/$idSantri/$idGroup'));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        // Pastikan data tidak null dan memiliki key 'data'
        if (data == null || !data.containsKey('data')) {
          throw Exception('Invalid API response: Missing "data" key');
        }

        final List list = data['data'];
        // Jika data valid, return hasil mapping ke List<TargetByGroup>
        return list.map((e) => TargetByGroup.fromJson(e)).toList();
      } catch (e) {
        throw Exception('Error parsing response: $e');
      }
    } else if (response.statusCode == 404) {
      // Jika data tidak ditemukan, return list kosong
      return [];
    } else {
      // Menangani status code lain seperti 500 (Internal Server Error)
      throw Exception('Failed to load target hafalan: ${response.statusCode}');
    }
  }

  static Future<dynamic> createTarget(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/target'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // ✅ return jadi bisa dipakai
    } else {
      throw Exception('Gagal menambahkan target hafalan');
    }
  }

  Future<void> updateTarget(int idTarget, Map<String, dynamic> payload) async {
    final response = await http.put(
      Uri.parse('$baseUrl/target/$idTarget'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal update target hafalan');
    }
  }

  Future<void> deleteById(int idTarget) async {
    final response = await http.delete(Uri.parse('$baseUrl/target/$idTarget'));
    if (response.statusCode != 200) {
      throw Exception('Gagal hapus target');
    }
  }

  Future<void> deleteBySantriGroup(int idSantri, int idGroup) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/target/$idSantri/$idGroup'));
    if (response.statusCode != 200) {
      throw Exception('Gagal hapus target santri-group');
    }
  }
}
