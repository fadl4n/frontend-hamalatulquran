import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailDataLayout extends StatelessWidget {
  final String imageUrl;
  final String gender;
  final Widget detailContent;
  const DetailDataLayout(
      {super.key,
      required this.imageUrl,
      required this.gender,
      required this.detailContent});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 30.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            margin: EdgeInsets.only(top: 60.h),
            padding: EdgeInsets.only(
                top: 70.h, bottom: 30.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r),
              ),
            ),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: detailContent,
            ),
          ),

          // Avatar
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 55.w,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55.r,
                  backgroundColor: Colors.green.shade50,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 100.r,
                      height: 100.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          gender == "Laki-Laki"
                              ? "assets/ikhwan.png"
                              : "assets/akhwat.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
