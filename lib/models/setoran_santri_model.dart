import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/setoran_model.dart';

class SetoranSantriModel {
  final String message;
  final Santri? santri;
  final List<Setoran> setorans;

  SetoranSantriModel({
    required this.message,
    this.santri,
    required this.setorans,
  });

  factory SetoranSantriModel.fromJson(Map<String, dynamic> json) {
    return SetoranSantriModel(
      message: json['message'] ?? 'No message provided',
      santri: json['santri'] != null ? Santri.fromJson(json['santri']) : null,
      setorans: (json['setorans'] as List<dynamic>? ?? []).map((item) {
        print('🛠️ Mapping setorans...');
        print('📍Item: $item');
        return Setoran.fromJson(item);
      }).toList(),
    );
  }
}
