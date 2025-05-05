import 'package:frontend_hamalatulquran/models/kelas_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';

class KelasRepository {
  static Future <List<Kelas>> getAll() async {
    return await ApiService().fetchKelas();
  }
}