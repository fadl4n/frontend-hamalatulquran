import 'hafalan_base.dart';

class Histori implements HafalanBase {
  final int idHistori;
  final int idSetoran;
  final int idTarget;
  final int idSurat;
  final int status;
  final int nilai;
  final int? nilaiRemed;

  final String _namaSurat;
  final int _jumlahAyat;
  final String _persentase;

  @override
  String get namaSurat => _namaSurat;

  @override
  int get jumlahAyat => _jumlahAyat;

  @override
  String get persentase => _persentase;

  @override
  DateTime get tglTarget => DateTime(2000); // Atau bisa disesuaikan

  Histori({
    required this.idHistori,
    required this.idSetoran,
    required this.idTarget,
    required this.idSurat,
    required String namaSurat,
    required int jumlahAyat,
    required String persentase,
    required this.status,
    required this.nilai,
    this.nilaiRemed,
  })  : _namaSurat = namaSurat,
        _jumlahAyat = jumlahAyat,
        _persentase = persentase;

  factory Histori.fromJson(Map<String, dynamic> json) {
    return Histori(
      idHistori: json['id_histori'],
      idSetoran: json['id_setoran'] ?? 0,
      idTarget: json['id_target'],
      idSurat: json['id_surat'],
      namaSurat: json['nama_surat'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      persentase: json['persentase']?.toString() ?? '0',
      status: json['status'] ?? 0,
      nilai: json['nilai'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Murojaah(namaSurat: $namaSurat, status: $status, nilai: $nilai)';
  }
}
