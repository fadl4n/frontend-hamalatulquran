import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderEvaluasi extends StatelessWidget {
  final String title;
  final int? jumlahAyat;
  final String? targetAyat;
  final String? progres;

  const HeaderEvaluasi({
    Key? key,
    required this.title,
    this.jumlahAyat,
    this.targetAyat,
    this.progres,
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

          // Kalau jumlahAyat ada, tampilkan info kelas
          if (jumlahAyat != null)
            Text(
              "Jumlah Ayat: $jumlahAyat Ayat",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),

          if (targetAyat != null) ...[
            Text(
              "Target ayat: $targetAyat",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ],
          if (progres != null) ...[
            Text(
              "Progress: $progres",
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
