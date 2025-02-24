import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io'; // Untuk Android & iOS
import 'package:flutter/foundation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 60.h,
        title: Text(
          "Profil",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: SizedBox(
          width: 60.w,
          height: 60.h,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Center(
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.w),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Container(
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage:
                              const AssetImage('assets/profile.jpg'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Rizka",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "2201091013",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Center(
            child: Card(
              elevation: 5,
              shadowColor: Colors.black26,
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem(context, Icons.visibility, "Data Pengajar"),
                  const Divider(),
                  _buildMenuItem(context, Icons.lock, "Ganti Kata Sandi"),
                  const Divider(),
                  _buildMenuItem(context, Icons.logout_outlined, "Keluar"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          if (title == "Keluar") {
            _showExitDialog(context);
          } else if (title == "Ganti Kata Sandi") {
            Navigator.pushNamed(context, '/ganti-pw');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(
                  size: 22.w,
                  weight: 700,
                  color: Colors.black54,
                ),
                child: Icon(icon),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
              IconTheme(
                data: IconThemeData(
                  size: 16.w,
                  weight: 700,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    bool isExiting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Keluar Aplikasi",
              style: GoogleFonts.poppins(
                  fontSize: 16.sp, fontWeight: FontWeight.bold)),
          content: Text("Apakah Anda yakin ingin keluar?",
              style: GoogleFonts.poppins(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w500)),
            ),
            TextButton(
              onPressed: () {
                if (!isExiting) {
                  isExiting = true;

                  if (kIsWeb) {
                    // 🚀 Web GAK bisa close app, jadi kasih info aja
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Keluar tidak didukung di Web")),
                    );
                  } else if (Platform.isAndroid) {
                    SystemNavigator.pop(); // Android ✅
                  } else if (Platform.isIOS) {
                    exit(0); // iOS ✅ (Apple nggak rekomendasi)
                  }
                }
              },
              child: Text("Keluar",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
