import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';
import 'package:frontend_hamalatulquran/repositories/kelas_repository.dart';
import 'package:frontend_hamalatulquran/widgets/layout/tabel_content_section.dart';
import 'package:intl/intl.dart';

import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/layout/header_section.dart';

class DataInfaq extends StatefulWidget {
  const DataInfaq({super.key});

  @override
  State<DataInfaq> createState() => _DataInfaqState();
}

class _DataInfaqState extends State<DataInfaq> {
  List<Kelas> kelasList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getAllKelas();
  }

  void _getAllKelas() async {
    try {
      List<Kelas> data = await KelasRepository.getAll();
      setState(() {
        kelasList = data;
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
      appBar: CustomAppbar(title: "Data Rekap Infaq", fontSize: 16.sp),
      body: Column(
        children: [
          const HeaderSection(
            title: "Infaq Hamalatul Qur'an",
            totalInfaq: "1.000.000,00",
          ),
          Expanded(
              child: TabelContentSection(
            isLoading: isLoading,
            title: "Data Infaq",
            headers: [getFormattedDate(), "Kelas", "Jumlah"],
            rows: kelasList.map((kelas) {
              return [
                " ",
                kelas.nama,
                "-", // Placeholder jumlah infaq misalnya
              ];
            }).toList(),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () {
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
}
