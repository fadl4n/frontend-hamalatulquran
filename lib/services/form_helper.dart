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

Widget buildTextField(String hintText,
    {bool readOnly = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    readOnly: readOnly,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.green.shade100,
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
    ),
  );
}
