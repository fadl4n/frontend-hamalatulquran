import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_hamalatulquran/models/target_hafalan_model.dart';

import '../api/api_exception.dart';

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

  static Future<List<TargetHafalan>> fetchAllTargetBySantri(
      String idSantri) async {
    final url = Uri.parse('$baseUrl/target/santri/$idSantri');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((item) => TargetHafalan.fromJson(item))
              .toList();
        }
        return [];
      } else if (response.statusCode == 404) {
        print("Data target tidak ditemukan untuk santri ID: $idSantri");
        return []; // data kosong, bukan error
      } else {
        print('Failed response: ${response.body}');
        throw Exception('Gagal mendapatkan data Target Hafalan');
      }
    } catch (e) {
      print('Error fetching Target by idSantri: $e');
      return [];
    }
  }

  static Future<dynamic> createTarget(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/target'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // ✅ return jadi bisa dipakai
      } else {
        String message = 'Terjadi Kesalahan';
        try {
          final jsonData = jsonDecode(response.body);
          if (jsonData is Map<String, dynamic> &&
              jsonData.containsKey('message')) {
            message = jsonData['message'];
          }
        } catch (_) {}
        throw ApiException(message, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Terjadi Kesalahan saat mengirim Target');
      }
    }
  }

  static Future<Map<String, dynamic>> updateTarget(
      int idTarget, Map<String, dynamic> payload) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/target/$idTarget'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 5));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print("❗ Response gagal dengan status: ${response.statusCode}");

      print("➡️ PUT ke endpoint: $baseUrl/target/$idTarget");
      print("📦 Payload: $payload");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // ✅ return jadi bisa dipakai
      } else {
        String message = 'Terjadi Kesalahan';
        try {
          final jsonData = jsonDecode(response.body);
          if (jsonData is Map<String, dynamic> &&
              jsonData.containsKey('message')) {
            message = jsonData['message'];
          }
        } catch (_) {}
        throw ApiException(message, response.statusCode);
      }
    } catch (e) {
      if (e is TimeoutException) {
        print("🕐 Timeout saat mengirim request ke updateTarget");
        throw ApiException("Request Timeout. Server Tidak merespon.");
      }
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Terjadi Kesalahan saat mengedit Target');
      }
    }
  }

  static Future<void> deleteTargetById(int idTarget) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/target/$idTarget'),
    );

    debugPrint('DELETE Status Code: ${response.statusCode}');
    debugPrint('DELETE Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus target');
    }
  }
}
