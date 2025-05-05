import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';
import 'package:google_fonts/google_fonts.dart';

class KelasTile extends StatelessWidget {
  final Kelas kelas;
  final VoidCallback onTap;
  const KelasTile({
    super.key,
    required this.kelas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 60.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              // Nama Kelas
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kelas.nama,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
