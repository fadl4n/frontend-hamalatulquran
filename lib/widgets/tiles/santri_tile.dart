import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile_components/profile_avatar.dart';

class SantriTile extends StatelessWidget {
  final Santri santri;
  final VoidCallback onTap;

  const SantriTile({
    super.key,
    required this.santri,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.r),
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
                // Avatar with Border
                ProfileAvatar(
                    imageUrl: santri.fotoSantri,
                    gender: santri.jenisKelamin,
                    size: 50.w),
                SizedBox(width: 10.w),

                // Nama & Info Santri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        santri.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${santri.kelasNama} \u2022 ${santri.nisn}",
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
      ),
    );
  }
}
