import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/widgets/data_detail_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailDataPengajar extends StatefulWidget {
  final int id;
  const DetailDataPengajar({super.key, required this.id});

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.r),
            ),
          ),
        ),
        title: Text(
          "Data Pengajar",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20.r),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ),
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

          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 30.h),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.fromLTRB(16.w, 70.h, 16.w, 10.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: Column(
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
                  ),
                ),
                Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width / 2 - 55.w,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55.r,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: pengajarPict,
                            width: 100.r,
                            height: 100.r,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) {
                              print("❌ Gagal load gambar: $url $error");
                              return Image.asset(
                                pengajar.jenisKelamin == "Laki-Laki"
                                    ? "assets/ikhwan.png"
                                    : "assets/akhwat.png",
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
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
