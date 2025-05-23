import 'package:intl/intl.dart';

String formatNamaPengajar(String nama, dynamic jenisKelaminKode) {
  if (jenisKelaminKode == 1) return 'Ustadz $nama';
  if (jenisKelaminKode == 2) return 'Ustadzah $nama';
  return nama;
}

String formatTanggal(dynamic tanggal) {
  try {
    DateTime date;

    if (tanggal is String) {
      date = DateTime.parse(tanggal);
    } else if (tanggal is DateTime) {
      date = tanggal;
    } else {
      return "-";
    }

    final formatter = DateFormat("d MMMM y", "id_ID");
    return formatter.format(date);
  } catch (e) {
    return tanggal; // fallback kalau error parsing
  }
}
