import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/home_bg.dart';
import '../widgets/menu_grid.dart';
import '../widgets/profile_icon.dart';

class HomePage extends StatelessWidget {
  final bool isPengajar; // Tambah kondisi apakah Pengajar atau Wali Santri
  const HomePage({super.key, required this.isPengajar}); //Terima Parameter

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HomeBackground(),
        const ProfileIcon(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 200.h), // Geser semua elemen ke bawah
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MenuGrid(isPengajar: isPengajar), // Hapus Flexible di sini
                  SizedBox(height: 25.h), // Kurangi jarak antar widget
                  _buildSantriAktifCard(),
                  SizedBox(height: 5.h), // Sesuaikan agar lebih rapat
                  Flexible(
                    child: _buildNewsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSantriAktifCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Center(
        child: Container(
          width: 0.9.sw, // 90% dari layar
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              colors: [
                Colors.green.shade300, // Warna hijau di kiri
                Colors.white, // Warna putih di kanan
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.r,
                offset: Offset(2.r, 2.r),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Text(
                  "0", // Jumlah santri aktif (nanti bisa dibuat dynamic)
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 7.w),
                FittedBox(
                  child: Text(
                    "Santri Aktif",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Center(
              child: Container(
                width: 0.85.sw,
                constraints: BoxConstraints(maxWidth: 400.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4 Februari 2025',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Pelepasan Angkatan 48',
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Lihat Selengkapnya',
                                style: TextStyle(fontSize: 14.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
