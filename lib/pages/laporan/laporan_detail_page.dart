import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/repositories/santri_repository.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/custom_table.dart';
import 'package:frontend_hamalatulquran/widgets/data_detail_shimmer.dart';
import 'package:frontend_hamalatulquran/widgets/detail_data_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class LaporanDetailPage extends StatefulWidget {
  final int id;
  final String nama;
  const LaporanDetailPage({super.key, required this.id, required this.nama});

  @override
  State<LaporanDetailPage> createState() => _LaporanDetailPageState();
}

class _LaporanDetailPageState extends State<LaporanDetailPage> {
  late Future<Santri> _futureSantri;

  @override
  void initState() {
    super.initState();
    _futureSantri = SantriRepository.getbyId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppbar(title: "Laporan Detail ${widget.nama}", fontSize: 16),
      body: FutureBuilder(
        future: _futureSantri,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DataDetailShimmer();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final santri = snapshot.data!;
          final nama = santri.nama;
          final nisn = santri.nisn;
          final santriPict = (santri.fotoSantri?.isNotEmpty ?? false)
              ? santri.fotoSantri!
              : "https://via.placeholder.com/150";

          print("📸 profil pict Santri: ${santri.fotoSantri}");
          return DetailDataLayout(
            imageUrl: santriPict,
            gender: santri.jenisKelamin,
            detailContent: Column(
              children: [
                buildSectionTitle("Data Pribadi"),
                buildDetailRow("Nama", nama),
                buildDetailRow("NISN", nisn),
                buildDetailRow("Tempat, tanggal lahir",
                    "${santri.tempatLahir}, ${santri.tglLahir}"),
                buildDetailRow("Jenis Kelamin", santri.jenisKelamin),
                buildDetailRow("Kelas", santri.kelasNama),
                SizedBox(height: 6.h),
                buildSectionTitle("Laporan"),
                Text(
                  "1. Hafalan Baru",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                const CustomTable(
                  headers: ["No", "Hafalan", "Nilai"],
                  rows: [
                    ["a.", "Surat Al-Fatihah", "80"],
                    ["b.", "Surat 2", "80"],
                    ["c.", "Surat 3", "80"],
                    ["d.", "Surat 4", "80"],
                    ["e.", "Surat 5", "80"],
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  "2. Muraja'ah",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                const CustomTable(
                  headers: ["No", "Hafalan", "Nilai"],
                  rows: [
                    ["a.", "Surat Al-Fatihah", "80"],
                    ["b.", "Surat 2", "80"],
                    ["c.", "Surat 3", "80"],
                    ["d.", "Surat 4", "80"],
                    ["e.", "Surat 5", "80"],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Divider(
            thickness: 2,
            height: 1,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
