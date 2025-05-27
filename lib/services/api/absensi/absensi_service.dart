import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/absen_santri_model.dart';

class AbsensiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/absen';

  static Future<List<AbsenSantri>> fetchAbsenSantri(int idKelas) async {
    final url = Uri.parse('$_baseUrl/detail/$idKelas');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List santriList = data['santris'];
        return santriList.map((e) => AbsenSantri.fromJson(e)).toList();
      } else {
        throw Exception("Gagal mengambil data absen");
      }
    } catch (e) {
      print('Error fetching Absen kelas: $e');
      return [];
    }
  }

  static Future<bool> simpanAbsensi({
    required String tanggal,
    required List<Map<String, dynamic>> data,
  }) async {
    final url = Uri.parse('$_baseUrl/simpan');

    final body = {
      'tgl_absen': tanggal,
      'data': data.map((e) {
        return {
          'id_kelas': e['id_kelas'], // ganti nama field
          'id_santri': e['id_santri'],
          'nisn': e['nisn'], // pastikan field ini dikirim
          'status': e['status'],
        };
      }).toList(),
    };

    try {
      print(jsonEncode(body));
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN_IF_NEEDED',
        },
        body: jsonEncode(body),
      );
      // Tambahkan print untuk response body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Gagal simpan absensi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error kirim absensi: $e');
      return false;
    }
  }
}
