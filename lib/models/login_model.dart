class User {
  final int id;
  final String role;
  final String token;
  final String fotoProfil;
  final String jenisKelamin;

  User({
    required this.id,
    required this.role,
    required this.token,
    required this.fotoProfil,
    required this.jenisKelamin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      token: json['token'],
      fotoProfil: json['foto_profil'] ?? "assets/user.png",
      jenisKelamin: json['jenis_kelamin'] == 1 ? "Laki-Laki" : "Perempuan",
    );
  }
}
