class Setoran {
  final int idSurat;
  final String namaSurat;
  final String ayat;
  final String pengajar;
  final int jenisKelaminPengajar;
  final String tanggal;
  final String keterangan;

  Setoran({
    required this.idSurat,
    required this.namaSurat,
    required this.ayat,
    required this.pengajar,
    required this.jenisKelaminPengajar,
    required this.tanggal,
    required this.keterangan,
  });

  factory Setoran.fromJson(Map<String, dynamic> json) {
    return Setoran(
      idSurat: json['id_surat'],
      namaSurat: json['nama_surat'] ?? '-',
      ayat: json['ayat'] ?? '-',
      pengajar: json['pengajar'] ?? '-',
      jenisKelaminPengajar: json['jenis_kelamin_pengajar'],
      tanggal: json['tanggal'] ?? '-',
      keterangan: json['keterangan'] ?? '-',
    );
  }
}
