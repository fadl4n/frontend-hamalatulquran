class Kelas {
  final int id;
  final String nama;
  final int? jumlahSantri;

  Kelas({
    required this.id,
    required this.nama,
    this.jumlahSantri,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    print("📥 Data Kelas dari API: $json");

    return Kelas(
      id: json['id_kelas'] ?? 0,
      nama: json['nama_kelas'] ?? "Tidak Ada Nama",
      jumlahSantri: int.tryParse(json['jumlah_santri'].toString()) ?? 0,
    );
  }
}
