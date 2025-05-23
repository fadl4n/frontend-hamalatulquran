import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 80.h),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 0.6.sw,
              height: 300.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 40.h),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 0.9.sw,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
