import 'package:frontend_hamalatulquran/models/santri_model.dart';

import '../services/api/api_service.dart';

class SantriRepository {
  static Future<List<Santri>> getAll() async {
    return await ApiService().fetchSantri();
  }

  static Future<Santri> getbyId(int id) async {
    return await ApiService.fetchSantribyId(id);
  }

  static Future<Map<String, dynamic>> getLaporanDetail(int id) async {
    return await ApiService.getLaporanDetail(id);
  }

  static Future<List<Santri>> getbyKelasId(int idKelas) async {
    return await ApiService().fetchSantriByKelas(idKelas);
  }

  static Future<int> getJumlahSantri(int id) async {
    return await ApiService().countSantriAktif();
  }
}
