import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile_components/profile_avatar.dart';

class PengajarTile extends StatelessWidget {
  final Pengajar pengajar;
  final VoidCallback onTap;
  const PengajarTile({
    super.key,
    required this.pengajar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.20),
                blurRadius: 15,
                offset: const Offset(2, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              ProfileAvatar(
                  imageUrl: pengajar.fotoPengajar,
                  gender: pengajar.jenisKelamin,
                  size: 50.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengajar.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pengajar.nip,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
