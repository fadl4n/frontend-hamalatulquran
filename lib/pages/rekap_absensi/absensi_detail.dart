import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/services/api/absensi/absensi_service.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/forms/absensi_kelas_form.dart';
import 'package:frontend_hamalatulquran/widgets/layout/tabel_content_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/absen_santri_model.dart';
import '../../widgets/layout/header_section.dart';

class AbsensiDetail extends StatefulWidget {
  final int id;
  final String namaKelas;
  const AbsensiDetail({super.key, required this.id, required this.namaKelas});

  @override
  State<AbsensiDetail> createState() => _AbsensiDetailState();
}

class _AbsensiDetailState extends State<AbsensiDetail> {
  List<AbsenSantri> absenSantriList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getAbsenSantribyKelas();
  }

  Future<void> _getAbsenSantribyKelas() async {
    try {
      List<AbsenSantri> data = await AbsensiService.fetchAbsenSantri(widget.id);
      setState(() {
        absenSantriList = data;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      print("❌ Error: $e");
      print("📌 Stacktrace: $stacktrace");
      setState(() {
        isLoading = false;
        errorMessage = "Gagal mengambil data. Silakan coba lagi nanti.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
          title: "Absensi Kelas ${widget.namaKelas}", fontSize: 16.sp),
      body: Column(
        children: [
          HeaderSection(
            title: widget.namaKelas,
            jumlahSantri: absenSantriList.length,
          ),
          Expanded(
              child: TabelContentSection(
            headers: ["NISN", "Nama", getFormattedDate()],
            rows: absenSantriList.map((s) {
              // Ambil status absens pertama atau "-" kalau kosong
              String statusAbsensi = s.absens.isNotEmpty
                  ? getStatusString(s.absens.first.status)
                  : getStatusString(0);
              return [
                s.nisn,
                s.nama,
                statusAbsensi, // status Absennya disini
              ];
            }).toList(),
            isLoading: isLoading,
            title: "Absensi Kelas",
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () async {
          final result = await showAbsensiDialog(context, widget.id, widget.namaKelas);

          if (result == true) {
            await _getAbsenSantribyKelas();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(now);
  }

  // Helper fungsi untuk ubah status absen int ke String
  String getStatusString(int status) {
    switch (status) {
      case 1:
        return "Hadir";
      case 2:
        return "Sakit";
      case 3:
        return "Izin";
      case 4:
        return "Alfa";
      default:
        return "Belum Absen";
    }
  }
}
