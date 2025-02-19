import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // Setelah 3 detik, pindah ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63A46C), // Warna hijau dari desain
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Pastikan logo ada di folder assets
          width: 150, // Sesuaikan ukuran logo
        ),
      ),
    );
  }
}
