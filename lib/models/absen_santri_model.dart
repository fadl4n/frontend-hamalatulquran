import 'absensi_model.dart';

class AbsenSantri {
  final List<Absensi> absens;
  final int id;
  final String nisn;
  final String nama;
  final int jenisKelamin;

  AbsenSantri({
    required this.id,
    required this.nama,
    required this.nisn,
    required this.jenisKelamin,
    required this.absens,
  });

  factory AbsenSantri.fromJson(Map<String, dynamic> json) {
    return AbsenSantri(
      id: json['id_santri'],
      nama: json['nama'],
      nisn: json['nisn'],
      jenisKelamin: json['jenis_kelamin'],
      absens: (json['absens'] != null)
          ? (json['absens'] as List).map((e) => Absensi.fromJson(e)).toList()
          : [],
    );
  }
}
