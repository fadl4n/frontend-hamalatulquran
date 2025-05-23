import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/appbar/custom_appbar.dart';

class GantiPassword extends StatelessWidget {
  const GantiPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Ganti Password", fontSize: 18.sp),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
        child: Column(
          children: [
            _buildTextField("Kata Sandi Lama"),
            SizedBox(height: 15.h),
            _buildTextField("Kata Sandi Baru"),
            SizedBox(height: 15.h),
            _buildTextField("Konfirmasi Kata Sandi Baru"),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.w),
              ),
              child: Text(
                "Simpan Perubahan",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.green.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    );
  }
}
