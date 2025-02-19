import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Warna Hijau Full Layar
        Container(
          height: screenHeight,
          width: double.infinity,
          color: const Color(0xFF4CAF50), // Warna hijau utama
        ),

        // Siluet Masjid (50% layar, di atas)
        Positioned(
          top: 10, // Bagian atas tetap fix
          left: 0,
          right: 0,
          child: FractionallySizedBox(
            widthFactor:
                1.4, // Atur lebarnya (1.0 = layar penuh, >1.0 lebih lebar)
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.5, // Tinggi tetap 50% layar
              child: Opacity(
                opacity: 0.3, // Transparansi gambar
                child: Image.asset(
                  'assets/masjid.png',
                  fit: BoxFit.cover,
                  alignment: Alignment
                      .topCenter, // Biar bagian atas fix, cuma melebar ke samping
                ),
              ),
            ),
          ),
        ),

        // **Layer Putih Full Layar**
        Container(
          height: screenHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Putih solid (Bawah)
                Colors.white.withOpacity(0.7),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.0), // Transparan di atas
              ],
              begin: Alignment.center,
              end: Alignment.topCenter,
            ),
          ),
        ),

        Positioned(
          top: 100, // Sesuaikan posisi
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Sejajar di tengah
            children: [
              // Logo
              Image.asset(
                'assets/logo.png', // Ganti dengan logo pesantren
                height: 110,
              ),
              const SizedBox(width: 10), // Jarak antara logo & teks
              // Nama Pesantren
              Text(
                "PONDOK PESANTREN\nHAMALATUL QUR'AN",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
