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
      final data = json.decode(response.body);
      final List list = data['data'];
      return list.map((e) => TargetByGroup.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      // kalau data gak ketemu, balikin list kosong aja
      return [];
    } else {
      throw Exception('Failed to load target hafalan');
    }
  }

  static Future<void> createTarget(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/target'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      print('Response body: ${response.body}');
      throw Exception('Gagal tambah target hafalan');
    } else {
      print('Target berhasil ditambahkan: ${response.body}');
      return jsonDecode(response.body);
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
