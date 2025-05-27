import 'dart:convert';
import 'package:frontend_hamalatulquran/models/setoran_model.dart';
import 'package:frontend_hamalatulquran/services/env.dart';
import 'package:http/http.dart' as http;
import '../api/api_exception.dart';

class SetoranService {
  static String baseUrl = Environment.baseUrl;

  static Future<List<Setoran>> getSetoranSantriByTarget(
      int idSantri, int idTarget) async {
    final url = Uri.parse('$baseUrl/setoran/target-santri/$idSantri-$idTarget');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((item) => Setoran.fromJson(item))
              .toList();
        }
        return [];
      } else {
        print('Failed response: ${response.body}');
        throw Exception('Gagal mendapatkan data setoran');
      }
    } catch (e) {
      print('Error fetching setoran by target: $e');
      return [];
    }
  }

  static Future<dynamic> createSetoran(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/setoran'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      // Tambahkan print untuk response body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      String message = 'Terjadi kesalahan';
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('message')) {
          message = jsonData['message'];
        }
      } catch (_) {}
      throw ApiException(message, response.statusCode);
    }
    } catch (e) {
      if (e is ApiException) {
        // lempar lagi response supaya bisa ditangani di atas
        rethrow;
      } else {
        print('Error creating setoran: $e');
        throw Exception('Terjadi kesalahan saat mengirim setoran');
      }
    }
  }
}
