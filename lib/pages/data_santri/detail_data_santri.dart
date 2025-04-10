import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailDataSantri extends StatefulWidget {
  final int id;
  const DetailDataSantri({super.key, required this.id});

  @override
  State<DetailDataSantri> createState() => _DetailDataSantriState();
}

final apiService = ApiService();

class _DetailDataSantriState extends State<DetailDataSantri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 60.h,
        title: Text(
          "Data Santri",
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
      body: FutureBuilder<Santri>(
        future: apiService.fetchSantribyId(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final santri = snapshot.data!;
          final nama = santri.nama;
          final nisn = santri.nisn;
          final santriPict = santri.fotoSantri?.isNotEmpty == true
              ? santri.fotoSantri!
              : "https://via.placeholder.com/150";

          print("📸 profil pict Santri: ${santri.fotoSantri}");

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Card
                Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.only(
                      top: 70.h, bottom: 20.h, left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Column(
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
                      buildDetailRow(
                          "Kelas", santri.kelasNama ?? "Belum ada kelas"),

                      SizedBox(height: 10.h),

                      buildSectionTitle("Data Keluarga"),
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
                ),

                // Avatar
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
                          imageUrl: santriPict,
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            print("❌ Gagal load gambar: $url $error");
                            return Image.asset(
                              santri.jenisKelamin == "Laki-Laki"
                                  ? "assets/ikhwan.png"
                                  : "assets/akhwat.png",
                              fit: BoxFit.cover,
                            );
                          },
                        )),
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
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
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
    );
  }
}
