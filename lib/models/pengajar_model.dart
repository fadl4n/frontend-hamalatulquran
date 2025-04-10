class Pengajar {
  final int id;
  final String nama;
  final String nip;
  final String fotoPengajar;
  final String email;
  final String alamat;
  final String noTelp;
  final String jenisKelamin;

  Pengajar({
    required this.id,
    required this.nama,
    required this.nip,
    required this.fotoPengajar,
    required this.email,
    required this.alamat,
    required this.noTelp,
    required this.jenisKelamin,
  });

  factory Pengajar.fromJson(Map<String, dynamic> json) {
    bool isUstadz = json['jenis_kelamin'] == 1; // 1 = Laki-laki, 2 = Perempuan
    String defaultFoto = isUstadz
        ? "assets/ustadz.png"
        : "assets/ustadzah.png";

    return Pengajar(
      id: json['id'],
      nama: json['nama'],
      nip: json['nip'],
      fotoPengajar: (json['foto_pengajar']?.isNotEmpty == true)
          ? json['foto_pengajar']
          : defaultFoto,
      email: json['email'],
      alamat: json['alamat'],
      noTelp: json['no_telp'],
      jenisKelamin: isUstadz ? "Laki-Laki" : "Perempuan",
    );
  }
}
