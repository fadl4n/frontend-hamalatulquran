import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/api/api_service.dart';
import '../../services/utils/util.dart';

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
    final String? userJson = prefs.getString("user_data");

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);

      // Fix typo: key must be 'foto_profil' bukan 'foto_profile'
      final String? fotoProfil = userMap['foto_profil'];

      // Ambil role dan gender, default kalo null
      final String newRole = userMap["role"] ?? "pengajar";
      final String newGender =
          (userMap["jenis_kelamin"] == 2) ? "Perempuan" : "Laki-laki";

      if (fotoProfil != null && fotoProfil.isNotEmpty) {
        final fixedUrl = Utils.fixLocalhostURL(fotoProfil);
        final isNet = fixedUrl.startsWith("http");

        // Update state supaya UI rebuild dengan data terbaru
        if (mounted) {
          setState(() {
            imgP = fixedUrl;
            isNetwork = isNet;
            role = newRole;
            gender = newGender;
          });
        }
      } else {
        // Kalau gak ada foto, pastikan setState juga
        if (mounted) {
          setState(() {
            imgP = "assets/user.png";
            isNetwork = false;
            role = newRole;
            gender = newGender;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCirclePositioned();
        }
        return _buildAvatar();
      },
    );
  }

  // Versi loading biasa untuk placeholder CachedNetworkImage
  Widget _loadingCircleSimple() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 60,
        height: 60,
        decoration:
            const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      ),
    );
  }

  // Versi loading Positioned untuk build awal
  Widget _loadingCirclePositioned() {
    return Positioned(
      top: 60.h,
      right: 20.w,
      child: _loadingCircleSimple(),
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
                    placeholder: (context, url) => _loadingCircleSimple(),
                    errorWidget: (context, url, error) {
                      print("❌ Gagal load image dari $url, error: $error");
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
