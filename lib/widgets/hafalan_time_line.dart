import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HafalanTimeline extends StatelessWidget {
  final String surah;
  final String ayat;
  final String ustadz;
  final String tanggal;
  final String waktu;

  const HafalanTimeline({
    Key? key,
    required this.surah,
    required this.ayat,
    required this.ustadz,
    required this.tanggal,
    required this.waktu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: true,
      isLast: true,
      beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 3),
      afterLineStyle: const LineStyle(color: Colors.grey, thickness: 3),
      indicatorStyle: IndicatorStyle(
        width: 10.w,
        color: Colors.grey,
        indicatorXY: 0.2,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
      ),
      endChild: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                ayat,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              Text(
                ustadz,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              Text(
                "$tanggal  $waktu",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
