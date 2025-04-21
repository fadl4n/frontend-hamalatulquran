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
  final String? rawKelasNama;
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
    this.rawKelasNama,
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
      id: json['id_santri'],
      nama: json['nama'],
      tempatLahir: json['tempat_lahir'],
      tglLahir: json['tgl_lahir'],
      nisn: json['nisn'],
      alamat: json['alamat'],
      fotoSantri: foto, // ✅ Bisa null
      angkatan: json['angkatan'].toString(),
      idKelas: json['id_kelas'] as int?,
      rawKelasNama: json['kelas']?['nama_kelas'],
      jenisKelamin: isIkhwan ? "Laki-Laki" : "Perempuan",
      email: json['email'],
      status: json['status'].toString(),
    );
  }

  String get kelasNama => rawKelasNama ?? "belum ada kelas";

  // ✅ Getter buat ambil foto dengan fallback ke default
  String get fotoProfilSantri {
    return (fotoSantri != null && fotoSantri!.startsWith("http"))
        ? fotoSantri!
        : (jenisKelamin == "Laki-Laki"
            ? "assets/ikhwan.png"
            : "assets/akhwat.png");
  }
}
