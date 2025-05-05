import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/pages/data_pengajar/detail_data_pengajar.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/detail_data_santri.dart';
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
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginPage());
              case '/profile':
                return MaterialPageRoute(builder: (_) => const ProfilePage());
              case '/ganti-pw':
                return MaterialPageRoute(builder: (_) => const GantiPassword());
              case '/detail-pengajar':
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => DetailDataPengajar(id: id),
                );
              case '/detail-santri':
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => DetailDataSantri(id: id),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                        child:
                            Text("😵 Rute '${settings.name}' gak ditemukan!")),
                  ),
                );
            }
          },
        );
      },
    ),
  );
}
