import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  String imgP = "assets/user.png";
  bool isNetwork = false;
  String role = "pengajar";
  String gender = "Laki-laki";

  late Future<void> _initFuture;
  @override
  void initState() {
    super.initState();
    _initFuture = _loadProfileIcon();
  }

  Future<void> _loadProfileIcon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? userData = prefs.getStringList("user_data");

    role = userData?.elementAtOrNull(1) ?? "pengajar";
    gender = userData?.elementAtOrNull(3) ?? "Laki-laki";

    String path = await ApiService.getProfileIcon();

    if (mounted) {
      setState(() {
        imgP = path;
        isNetwork = path.startsWith("http");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCircle();
        }
        return _buildAvatar();
      },
    );
  }

  Widget _loadingCircle() {
    return Positioned(
      top: 60.h,
      right: 20.w,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 60,
          height: 60,
          decoration:
              const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Positioned(
      top: 60.h,
      right: 20.w,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: isNetwork
                ? CachedNetworkImage(
                    imageUrl: imgP,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _loadingCircle(),
                    errorWidget: (context, url, error) {
                      final fallback =
                          ApiService.getDefaultAssetByRoleGender(role, gender);
                      return Image.asset(fallback, fit: BoxFit.cover);
                    },
                  )
                : Image.asset(imgP, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
