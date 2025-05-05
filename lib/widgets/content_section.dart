import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentSection extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  const ContentSection({
    super.key,
    required this.title,
    required this.itemBuilder,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            )
          ],
        ),
      ),
    );
  }
}
