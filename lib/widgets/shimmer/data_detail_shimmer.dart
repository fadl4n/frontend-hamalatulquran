import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataDetailShimmer extends StatelessWidget {
  const DataDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card shimmer
          Container(
            margin: EdgeInsets.only(top: 60.h),
            padding: EdgeInsets.only(
                top: 70.h, bottom: 20.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Column(
              children: List.generate(3, (section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 150.w, height: 20.h, radius: 8.r),
                    SizedBox(height: 8.h),
                    ...List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            shimmerBox(width: 100.w, height: 14.h),
                            SizedBox(width: 12.w),
                            shimmerBox(width: 160.w, height: 14.h),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                );
              }),
            ),
          ),

          // Avatar shimmer
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 55.w,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: 55.r,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerBox(
      {double width = 100, double height = 20, double radius = 6}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
