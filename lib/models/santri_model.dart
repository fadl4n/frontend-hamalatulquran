class Santri {
  final int id;
  final String nama;
  final String tempatLahir;
  final String tglLahir;
  final String nisn;
  final String alamat;
  final String? fotoSantri;
  final String angkatan;
  final int? idKelas;
  final String? kelasNama;
  final String jenisKelamin;
  final String email;
  final String status;

  Santri({
    required this.id,
    required this.nama,
    required this.tempatLahir,
    required this.tglLahir,
    required this.nisn,
    required this.alamat,
    this.fotoSantri,
    required this.angkatan,
    required this.idKelas,
    this.kelasNama,
    required this.jenisKelamin,
    required this.email,
    required this.status,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    bool isIkhwan = json['jenis_kelamin'] == 1;
    String defaultFoto = isIkhwan ? "assets/ikhwan.png" : "assets/akhwat.png";

    print("📥 Data Santri dari API: $json");

    // ✅ Perbaiki validasi foto
    String? foto = (json['foto_santri'] != null &&
            json['foto_santri'].toString().isNotEmpty &&
            json['foto_santri'].toString() != "null")
        ? json['foto_santri']
        : null; // Biarkan null dulu, nanti di-handle di widget

    print("✅ Foto yang dipakai untuk ${json['nama']}: ${foto ?? defaultFoto}");

    return Santri(
      id: json['id_santri'] ?? 0,
      nama: json['nama'] ?? "Tidak Ada Nama",
      tempatLahir: json['tempat_lahir'] ?? "Tidak Ada Nama",
      tglLahir: json['tgl_lahir'] ?? "Tidak Ada Nama",
      nisn: json['nisn'] ?? "Tidak Ada NISN",
      alamat: json['alamat'] ?? "Tidak Ada Alamat",
      fotoSantri: foto, // ✅ Bisa null
      angkatan: json['angkatan']?.toString() ?? "Tidak Ada Angkatan",
      idKelas: json['id_kelas'] as int?,
      kelasNama: json['kelas']?['nama_kelas'],
      jenisKelamin: isIkhwan ? "Laki-Laki" : "Perempuan",
      email: json['email'] ?? "Tidak Ada Email",
      status: json['status']?.toString() ?? "Tidak Ada Status",
    );
  }

  // ✅ Getter buat ambil foto dengan fallback ke default
  String get fotoProfil {
    return (fotoSantri != null && fotoSantri!.startsWith("http"))
        ? fotoSantri!
        : (jenisKelamin == "Laki-Laki"
            ? "assets/ikhwan.png"
            : "assets/akhwat.png");
  }
}
