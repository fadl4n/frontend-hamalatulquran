class User {
  final int id;
  final String role;
  final String fotoProfil;
  final int jenisKelamin;
  final String token;

  User({
    required this.id,
    required this.role,
    required this.fotoProfil,
    required this.jenisKelamin,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      fotoProfil: json['foto_profil'] ?? "assets/user.png",
      jenisKelamin: json['jenis_kelamin'],
      token: json['token'],
    );
  }

  String get jenisKelaminStr {
    if (jenisKelamin == 1) {
      return "Laki-laki";
    } else if (jenisKelamin == 2) {
      return "Perempuan";
    } else {
      return "Belum diisi";
    }
  }
}
