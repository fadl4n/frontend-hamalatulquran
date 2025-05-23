import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/repositories/santri_repository.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';

import '../../widgets/layout/detail_data_layout.dart';
import '../../widgets/shimmer/data_detail_shimmer.dart';

class DetailDataSantri extends StatefulWidget {
  final int id;
  final String? nama;
  const DetailDataSantri({super.key, required this.id, this.nama});

  @override
  State<DetailDataSantri> createState() => _DetailDataSantriState();
}

class _DetailDataSantriState extends State<DetailDataSantri> {
  late Future<Santri> _futureSantri;

  @override
  void initState() {
    super.initState();
    _futureSantri = SantriRepository.getbyId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: (widget.nama?.isNotEmpty ?? false)
              ? "Data ${widget.nama}"
              : "Profile Anda",
          fontSize: 16.sp),
      body: FutureBuilder<Santri>(
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
                buildDetailRow("Email", santri.email),
                // buildDetailRow("Phone", santri.phone),
                buildDetailRow("Alamat", santri.alamat),
                buildDetailRow("Kelas", santri.kelasNama),

                SizedBox(height: 10.h),

                buildSectionTitle("Data Ayah Kandung"),
                buildDetailRow("Nama Bapak Kandung", "-"), // sementara
                buildDetailRow("Tempat, tanggal lahir", "-"),
                buildDetailRow("Keadaan Bapak Kandung", "-"),
                buildDetailRow("Pendidikan", "-"),
                buildDetailRow("Pekerjaan", "-"),
                buildDetailRow("Alamat", "-"),
                buildDetailRow("Phone", "-"),

                SizedBox(height: 10.h),

                buildSectionTitle("Data Ibu Kandung"),
                buildDetailRow("Nama Ibu Kandung", "-"),
                buildDetailRow("Tempat, tanggal lahir", "-"),
                buildDetailRow("Keadaan Ibu Kandung", "-"),
                buildDetailRow("Pendidikan", "-"),
                buildDetailRow("Pekerjaan", "-"),
                buildDetailRow("Alamat", "-"),
                buildDetailRow("Phone", "-"),

                SizedBox(height: 10.h),

                buildSectionTitle("Data Orang Tua Asuh/Wali"),
                buildDetailRow("Status Orang Tua Asuh/Wali", "-"),
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
