import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final VoidCallback? onBack;

  const CustomAppbar({
    super.key,
    required this.title,
    this.onBack,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: InkWell(
        onTap: onBack ?? () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Center(
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20.w),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
