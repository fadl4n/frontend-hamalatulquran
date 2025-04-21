class Pengajar {
  final int id;
  final String nama;
  final String nip;
  final String? fotoPengajar;
  final String email;
  final String alamat;
  final String noTelp;
  final String jenisKelamin;

  Pengajar({
    required this.id,
    required this.nama,
    required this.nip,
    this.fotoPengajar,
    required this.email,
    required this.alamat,
    required this.noTelp,
    required this.jenisKelamin,
  });

  factory Pengajar.fromJson(Map<String, dynamic> json) {
    bool isUstadz = json['jenis_kelamin'] == 1; // 1 = Laki-laki, 2 = Perempuan
    String defaultFoto = isUstadz ? "assets/ustadz.png" : "assets/ustadzah.png";

    print("📥 Data Pengajar dari API: $json");

    // ✅ Perbaiki validasi foto
    String? foto = (json['foto_pengajar'] != null &&
            json['foto_pengajar'].toString().isNotEmpty &&
            json['foto_pengajar'].toString() != "null")
        ? json['foto_pengajar']
        : null; // Biarkan null dulu, nanti di-handle di widget

    print("✅ Foto yang dipakai untuk ${json['nama']}: ${foto ?? defaultFoto}");

    return Pengajar(
      id: json['id_pengajar'],
      nama: json['nama'],
      nip: json['nip'],
      fotoPengajar: foto,
      email: json['email'],
      alamat: json['alamat'],
      noTelp: json['no_telp'],
      jenisKelamin: isUstadz ? "Laki-Laki" : "Perempuan",
    );
  }
  String get fotoProfilPengajar {
    return (fotoPengajar != null && fotoPengajar!.startsWith("http"))
        ? fotoPengajar!
        : (jenisKelamin == "Laki-Laki"
            ? "assets/ustadz.png"
            : "assets/ustadzah.png");
  }
}
