import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          top: 50.h, // Bagian atas tetap fix
          left: 0,
          right: 0,
          child: FractionallySizedBox(
            widthFactor:
                1.0, // Atur lebarnya (1.0 = layar penuh, >1.0 lebih lebar)
            child: SizedBox(
              height: screenHeight *
                  0.5, // Tinggi tetap 50% layar
              child: Opacity(
                opacity: 0.4, // Transparansi gambar
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

        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 70.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // **Logo Pesantren**
                Image.asset(
                  'assets/logo.png',
                  height: 90.h, // Dikurangi sedikit biar proporsional
                ),
                SizedBox(width: 12.w), // Jarak antara logo dan teks

                // **Nama Pesantren**
                Expanded(
                  child: Text(
                    "PONDOK PESANTREN\nHAMALATUL QUR'AN",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSerif(
                      color: Colors.white,
                      fontSize: 22, // Dikecilkan sedikit biar lebih pas
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
