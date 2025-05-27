import 'hafalan_base.dart';

class Histori implements HafalanBase {
  final int idHistori;
  final int idSetoran;
  final int idTarget;
  final int idSurat;
  final int status;
  final int? nilai;
  final int? nilaiRemed;

  final String _namaSurat;
  final int _jumlahAyat;
  final String _persentase;
  final DateTime _tglTarget;

  @override
  String get namaSurat => _namaSurat;

  @override
  int get jumlahAyat => _jumlahAyat;

  @override
  String get persentase => _persentase;

  @override
  DateTime get tglTarget => _tglTarget;

  Histori({
    required this.idHistori,
    required this.idSetoran,
    required this.idTarget,
    required this.idSurat,
    required String namaSurat,
    required int jumlahAyat,
    required String persentase,
    required DateTime tglTarget,
    required this.status,
    required this.nilai,
    this.nilaiRemed,
  })  : _namaSurat = namaSurat,
        _jumlahAyat = jumlahAyat,
        _persentase = persentase,
        _tglTarget = tglTarget;

  factory Histori.fromJson(Map<String, dynamic> json) {
    return Histori(
      idHistori: json['id_histori'],
      idSetoran: json['id_setoran'] ?? 0,
      idTarget: json['id_target'],
      idSurat: json['id_surat'],
      namaSurat: json['nama_surat'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      persentase: json['persentase']?.toString() ?? '0',
      tglTarget: json['tgl_target'] != null
          ? DateTime.parse(json['tgl_target'])
          : DateTime.now(),
      status: json['status'] ?? 0,
      nilai: json['nilai'] ?? 0,
      nilaiRemed: json['nilai_remedial'] ?? 0,
    );
  }

  Histori copyWith({
    int? idHistori,
    int? idSetoran,
    int? idTarget,
    int? idSurat,
    String? namaSurat,
    int? jumlahAyat,
    String? persentase,
    DateTime? tglTarget,
    int? status,
    int? nilai,
    int? nilaiRemed,
  }) {
    return Histori(
      idHistori: idHistori ?? this.idHistori,
      idSetoran: idSetoran ?? this.idSetoran,
      idTarget: idTarget ?? this.idTarget,
      idSurat: idSurat ?? this.idSurat,
      namaSurat: namaSurat ?? _namaSurat,
      jumlahAyat: jumlahAyat ?? _jumlahAyat,
      persentase: persentase ?? _persentase,
      tglTarget: tglTarget ?? _tglTarget,
      status: status ?? this.status,
      nilai: nilai ?? this.nilai,
      nilaiRemed: nilaiRemed ?? this.nilaiRemed,
    );
  }

  @override
  String toString() {
    return 'Murojaah(namaSurat: $namaSurat, status: $status, nilai: $nilai)';
  }
}
