class ProfileModel {
  final int id;
  final String nama;
  final String? nip;
  final String? nisn;
  final String tempatTanggalLahir;
  final int jenisKelamin;
  final String? noTelp;
  final String alamat;
  final String role;
  final String? fotoProfil;
  final int? kelas; // buat santri

  ProfileModel({
    required this.id,
    required this.nama,
    this.nip,
    this.nisn,
    required this.tempatTanggalLahir,
    required this.jenisKelamin,
    this.noTelp,
    required this.alamat,
    required this.role,
    this.fotoProfil,
    this.kelas,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      nama: json['nama'],
      nip: json['nip'],
      nisn: json['nisn'],
      tempatTanggalLahir: json['tempat_tanggal_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      noTelp: json['no_telp'],
      alamat: json['alamat'],
      role: json['role'] ?? '',
      fotoProfil: json['foto_profil'],
      kelas: json['kelas'], // null buat pengajar
    );
  }

  @override
  String toString() {
    return 'ProfileModel{id: $id, nama: $nama, nip: $nip, nisn: $nisn, tempatTanggalLahir: $tempatTanggalLahir, jenisKelamin: $jenisKelamin, noTelp: $noTelp, alamat: $alamat, role: $role, fotoProfil: $fotoProfil, idKelas: $kelas}';
  }

  String get fotoProfilSantri {
    if (fotoProfil != null && fotoProfil!.startsWith("http")) {
      return fotoProfil!;
    }
    // fallback default
    return jenisKelamin == 1 ? "assets/ikhwan.png" : "assets/akhwat.png";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nip': nip,
      'nisn': nisn,
      'foto_profil': fotoProfil,
    };
  }

  bool get isPengajar => nip != null;
  bool get isSantri => nisn != null;
}
