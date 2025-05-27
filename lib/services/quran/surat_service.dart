import 'dart:convert';
import 'package:frontend_hamalatulquran/services/env.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_hamalatulquran/models/surat_model.dart';

class SuratService {
  static String baseUrl = Environment.baseUrl;
  static Future<List<Surat>> fetchSuratList() async {
    final response = await http.get(Uri.parse("$baseUrl/surat")); // Ganti URL sesuai API

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Surat.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data surat");
    }
  }
}
