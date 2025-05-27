import 'dart:convert';
import 'package:frontend_hamalatulquran/models/histori_model.dart';
import 'package:http/http.dart' as http;
import '../env.dart';

class HistoriService {
  static String baseUrl = Environment.baseUrl;

  static Future<List<Histori>> fetchHistoriBySantri(int idSantri) async {
    final url = Uri.parse('$baseUrl/histori/santri/$idSantri');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Histori.fromJson(item)).toList();
      } else {
        print('Failed response: ${response.body}');
        throw Exception('Gagal mendapatkan data Murojaah Target Hafalan');
      }
    } catch (e) {
      print('Error fetching Murojaah by targetHafalan: $e');
      return [];
    }
  }

  Future<bool> updateNilaiMurojaah(int idHistori, int nilai,
      {int? nilaiRemedial}) async {
    final url = Uri.parse('$baseUrl/histori/input-nilai/$idHistori');

    final body = {
      'nilai': nilai,
      if (nilaiRemedial != null) 'nilai_remedial': nilaiRemedial,
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']); // Bisa juga ditampilin di UI
      return true;
    } else {
      throw Exception('Failed to update nilai');
    }
  }
}
