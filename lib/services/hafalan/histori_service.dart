import 'dart:convert';
import 'package:frontend_hamalatulquran/models/histori_model.dart';
import 'package:http/http.dart' as http;

class HistoriService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/histori';

  static Future<List<Histori>> fetchHistoriBySantri(int idSantri) async {
    final url = Uri.parse('$_baseUrl/santri/$idSantri');

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
}
