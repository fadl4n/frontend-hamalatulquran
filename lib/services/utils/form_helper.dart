import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLabel(String text) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.green.shade800,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    ),
  );
}

Widget buildTextField(String hint,
      {required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.green.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Field ini tidak boleh kosong';
            }
            return null;
          },
    );
  }
