import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shimmer/data_detail_shimmer.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String identifier;
  final String profilePict;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.identifier,
    required this.profilePict,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.6.sw,
      height: 300.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 55.r,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profilePict,
                    width: 110.r,
                    height: 110.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const DataDetailShimmer(),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/user.png", fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.r,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.edit, size: 16.w, color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Text(nama,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold)),
          Text(identifier,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 16.sp)),
        ],
      ),
    );
  }
}
