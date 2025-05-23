class UserModel {
  final int id;
  final String nama;
  final String role;
  final String? fotoProfil;
  final int jenisKelamin;
  final String token;

  UserModel({
    required this.id,
    required this.nama,
    required this.role,
    this.fotoProfil,
    required this.jenisKelamin,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        nama: json['nama'],
        role: json['role'],
        fotoProfil: json['foto_profil'],
        jenisKelamin: json['jenis_kelamin'],
        token: json['token']);
  }
  // Biar gampang ambil "Laki-laki" atau "Perempuan"
  String get jenisKelaminStr => jenisKelamin == 1 ? "Laki-laki" : "Perempuan";
}
