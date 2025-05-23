import 'hafalan_base.dart';

class TargetHafalan implements HafalanBase {
  final int _idTarget;
  final int _idSurat;
  final String _namaSurat;
  final int _jumlahAyat;
  final String _persentase;
  final DateTime _tglTarget;

  final int idPengajar;
  final String namaPengajar;
  final int jenisKelaminPengajar;
  final int ayatAwal;
  final int ayatAkhir;
  final DateTime tglMulai;
  final int nilai;

  @override
  int get idTarget => _idTarget;

  @override
  int get idSurat => _idSurat;

  @override
  String get namaSurat => _namaSurat;

  @override
  int get jumlahAyat => _jumlahAyat;

  @override
  String get persentase => _persentase;

  @override
  DateTime get tglTarget => _tglTarget;

  TargetHafalan({
    required int idTarget,
    required int idSurat,
    required String namaSurat,
    required int jumlahAyat,
    required String persentase,
    required DateTime tglTarget,
    required this.idPengajar,
    required this.namaPengajar,
    required this.jenisKelaminPengajar,
    required this.ayatAwal,
    required this.ayatAkhir,
    required this.tglMulai,
    required this.nilai,
  })  : _idTarget = idTarget,
        _idSurat = idSurat,
        _namaSurat = namaSurat,
        _jumlahAyat = jumlahAyat,
        _persentase = persentase,
        _tglTarget = tglTarget;

  factory TargetHafalan.fromJson(Map<String, dynamic> json) {
    print("nilai target: ${json['nilai']} (${json['nilai']?.runtimeType})");

    return TargetHafalan(
      idTarget: json['id_target'],
      idSurat: json['id_surat'],
      namaSurat: json['nama_surat'] ?? '',
      idPengajar: json['id_pengajar'] ?? 0,
      namaPengajar: json['nama_pengajar'] ?? '',
      jenisKelaminPengajar: json['jenis_kelamin_pengajar'] ?? 0,
      ayatAwal: json['ayat_awal'] ?? 0,
      ayatAkhir: json['ayat_akhir'] ?? 0,
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tglMulai: json['tgl_mulai'] != null
          ? DateTime.parse(json['tgl_mulai'])
          : DateTime.now(),
      tglTarget: json['tgl_target'] != null
          ? DateTime.parse(json['tgl_target'])
          : DateTime.now(),
      persentase: json['persentase']?.toString() ?? '0',
      nilai: (json['nilai'] is int)
          ? json['nilai']
          : (json['nilai'] is double)
              ? (json['nilai'] as double).round()
              : 0,
    );
  }

  @override
  String toString() {
    return 'Target Hafalan(namaSurat: $namaSurat, persentase: $persentase, nilai: $nilai)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id_target': idTarget,
      'nama_surat': namaSurat,
      'id_pengajar': idPengajar,
      'nama_pengajar': namaPengajar,
      'jenis_kelamin_pengajar': jenisKelaminPengajar,
      'ayat_awal': ayatAwal,
      'ayat_akhir': ayatAkhir,
      'jumlah_ayat': jumlahAyat,
      'tgl_mulai': tglMulai.toIso8601String(),
      'tgl_target': tglTarget.toIso8601String(),
      'persentase': persentase,
      'nilai': nilai,
    };
  }
}
