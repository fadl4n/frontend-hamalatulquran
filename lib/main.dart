import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/pages/ganti_pw.dart';
import 'package:frontend_hamalatulquran/screens/splash_screen.dart';
import 'package:frontend_hamalatulquran/pages/login_page.dart';
import 'package:frontend_hamalatulquran/pages/profile_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUserId = prefs.getString("user_id");
  print("📌 [DEBUG] User ID yang tersimpan di awal aplikasi: $savedUserId");
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
