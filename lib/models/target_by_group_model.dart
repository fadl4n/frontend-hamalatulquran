class TargetByGroup {
  final String namaSurat;
  final int ayatAwal;
  final int ayatAkhir;
  final int jumlahAyat;

  TargetByGroup({
    required this.namaSurat,
    required this.ayatAwal,
    required this.ayatAkhir,
    required this.jumlahAyat,
  });

  factory TargetByGroup.fromJson(Map<String, dynamic> json) {
    return TargetByGroup(
      namaSurat: json['nama_surat'],
      ayatAwal: json['ayat_awal'],
      ayatAkhir: json['ayat_akhir'],
      jumlahAyat: json['jumlah_ayat'] ?? 0,
    );
  }
}
