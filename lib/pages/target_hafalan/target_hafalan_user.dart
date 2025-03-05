import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/history_target_hafalan.dart';

class TargetHafalanUser extends StatefulWidget {
  final String nisn;

  const TargetHafalanUser({super.key, required this.nisn});

  @override
  State<TargetHafalanUser> createState() => _TargetHafalanUserState();
}

class _TargetHafalanUserState extends State<TargetHafalanUser> {
  List<Map<String, dynamic>> targetHafalan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTargetHafalan();
  }

  Future<void> fetchTargetHafalan() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      targetHafalan = [
        {'nama_surat': 'Al-Fatihah', 'jumlah_ayat': 7},
        {'nama_surat': 'Al-Baqoroh', 'jumlah_ayat': 286},
        {"nama_surat": "An-Naba'", 'jumlah_ayat': 40},
        {'nama_surat': "An-Nazi'at", 'jumlah_ayat': 46},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 60.h,
        title: Text(
          "Target Hafalan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _headerSection(),
                Expanded(child: _listHafalanSection()),
              ],
            ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: EdgeInsets.only(top: 40.h, bottom: 30.h),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Rizka",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "2201091013",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          Text(
            "Kelas 3A",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listHafalanSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
            ),
            Center(
              child: Text(
                "Target Hafalan",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: targetHafalan.length,
                itemBuilder: (context, index) {
                  var hafalan = targetHafalan[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryTargetHafalan(
                            namaSurat: hafalan['nama_surat'],
                            jumlahAyat: hafalan['jumlah_ayat'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hafalan['nama_surat'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Jumlah Ayat: ${hafalan['jumlah_ayat']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.black54, size: 18.w),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
