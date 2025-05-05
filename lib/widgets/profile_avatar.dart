import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String gender;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.gender,
    this.size = 50, // default size 50
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.green.shade400],
        ),
      ),
      padding: EdgeInsets.all(2.w),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: (imageUrl != null &&
                  imageUrl!.isNotEmpty &&
                  imageUrl!.startsWith("http"))
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: (size - 4).w,
                  height: (size - 4).w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: (size - 4).w,
                      height: (size - 4).w,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    gender == "Laki-Laki"
                        ? "assets/ikhwan.png"
                        : "assets/akhwat.png",
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  gender == "Laki-Laki"
                      ? "assets/ikhwan.png"
                      : "assets/akhwat.png",
                  width: (size - 4).w,
                  height: (size - 4).w,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
