class Surat {
  final int id;
  final String nama;
  final int ayat;

  Surat({required this.id, required this.nama, required this.ayat});

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      id: json['id_surat'],
      nama: json['nama_surat'],
      ayat: json['jumlah_ayat'],
    );
  }
}
