import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderEvaluasi extends StatelessWidget {
  final String title;
  final int? jumlahAyat;
  final int? progres;

  const HeaderEvaluasi({
    Key? key,
    required this.title,
    this.jumlahAyat,
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

          // Kalau nisn dan kelasSantri ada, tampilkan info santri
          if (progres != null) ...[
            Text(
              "Status: $progres",
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
