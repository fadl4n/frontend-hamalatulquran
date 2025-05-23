import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentSection extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext, int)? itemBuilder;
  final int? itemCount;
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final String? emptyMessage; // ✅ Tambahkan ini

  const ContentSection({
    super.key,
    required this.title,
    this.itemBuilder,
    this.itemCount,
    this.isLoading = false,
    this.errorMessage,
    this.isEmpty = false,
    this.emptyMessage, // ✅ Jangan lupa tambahkan di konstruktor
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      content = Center(child: Text("Error: $errorMessage"));
    } else if (isEmpty) {
      content = Center(
          child: Text(
              emptyMessage ?? "Belum ada data. 💤")); // ✅ Gunakan emptyMessage
    } else {
      content = ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder!,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 10.h)),
            Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
