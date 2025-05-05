import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/data_detail_shimmer.dart';
import 'package:frontend_hamalatulquran/widgets/detail_data_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';

class DetailDataPengajar extends StatefulWidget {
  final int id;
  final String? nama;
  const DetailDataPengajar({super.key, required this.id, this.nama});

  @override
  State<DetailDataPengajar> createState() => _DetailDataPengajarState();
}

class _DetailDataPengajarState extends State<DetailDataPengajar> {
  late Future<Pengajar> _futurePengajar;

  @override
  void initState() {
    super.initState();
    _futurePengajar = ApiService().fetchPengajarbyId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Data ${widget.nama}", fontSize: 16),
      body: FutureBuilder(
        future: _futurePengajar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DataDetailShimmer();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pengajar = snapshot.data!;
          final nama = pengajar.nama;
          final nip = pengajar.nip;
          final pengajarPict = (pengajar.fotoPengajar?.isNotEmpty ?? false)
              ? pengajar.fotoPengajar!
              : "https://via.placeholder.com/150";

          print("📸 profil pict Santri: ${pengajar.fotoPengajar}");
          return DetailDataLayout(
            imageUrl: pengajarPict,
            gender: pengajar.jenisKelamin,
            detailContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle("Data Pribadi"),
                buildDetailRow("Nama", nama),
                buildDetailRow("NIP", nip),
                buildDetailRow("Jenis Kelamin", pengajar.jenisKelamin),
                buildDetailRow("Email", pengajar.email),
                buildDetailRow("Phone", pengajar.noTelp),
                buildDetailRow("Alamat", pengajar.alamat),
                // buildDetailRow("Kelas", pengajar.kelasNama),
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
