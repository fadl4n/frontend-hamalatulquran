import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Row(
            children: [
              Icon(icon, size: 22.w, color: Colors.black54),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
