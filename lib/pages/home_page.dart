import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/home_bg.dart';
import '../widgets/menu_grid.dart';
import 'package:frontend_hamalatulquran/widgets/profile_icon.dart';

class HomePage extends StatelessWidget {
  final bool isPengajar; // Tambah kondisi apakah Pengajar atau Wali Santri
  
  const HomePage({super.key, required this.isPengajar}); //Terima Parameter

  @override
  Widget build(BuildContext context) {
    print("isPengajar di HomePage: $isPengajar"); // Debugging
    debugPrint("Building MenuGrid dengan isPengajar: $isPengajar");
    return Scaffold(
      key: ValueKey(isPengajar),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const HomeBackground(),
          const ProfileIcon(), // Pastikan ini tetap di atas biar bisa diklik
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 180.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuGrid(key: ValueKey(isPengajar), isPengajar: isPengajar),
                  SizedBox(height: 20.h),
                  _buildSantriAktifCard(),
                  SizedBox(height: 10.h),
                  Expanded(child: _buildNewsList()),
                ],
              ),
            ),
          ),
        ],
      ),
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
