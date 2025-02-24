import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/pages/ganti_pw.dart';
import 'package:frontend_hamalatulquran/screens/splash_screen.dart';
import 'package:frontend_hamalatulquran/pages/login_page.dart';
import 'package:frontend_hamalatulquran/pages/profile_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/profile': (context) => const ProfilePage(),
            '/ganti-pw': (context) => const GantiPassword()
          },
        );
      },
    ),
  );
}
