class Absensi {
  final String tanggal;
  final int status;

  Absensi({
    required this.tanggal,
    required this.status,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      tanggal: json['tgl_absen'],
      status: json['status'],
    );
  }
}
