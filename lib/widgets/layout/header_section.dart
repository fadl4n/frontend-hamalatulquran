import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String? nisn;
  final int? jumlahSantri;
  final String? kelasSantri;
  final String? totalInfaq;

  const HeaderSection({
    Key? key,
    required this.title,
    this.nisn,
    this.jumlahSantri,
    this.kelasSantri,
    this.totalInfaq,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),

          // Kalau jumlahSantri ada, tampilkan info kelas
          if (jumlahSantri != null)
            Text(
              "Jumlah Santri: $jumlahSantri Santri",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),

          // Kalau nisn dan kelasSantri ada, tampilkan info santri
          if (nisn != null && kelasSantri != null) ...[
            Text(
              "NISN: $nisn",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            Text(
              "Kelas: $kelasSantri",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            if (totalInfaq != null)
            Text(
              "Total Infaq: Rp. $totalInfaq",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
