import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/pages/rekap_absensi/absensi_detail.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';

class RekapAbsensi extends StatefulWidget {
  const RekapAbsensi({super.key});

  @override
  State<RekapAbsensi> createState() => _RekapAbsensiState();
}

class _RekapAbsensiState extends State<RekapAbsensi> {
  late Future<List<Kelas>> futureKelas;

  @override
  void initState() {
    super.initState();
    futureKelas = ApiService().fetchKelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.r),
            ),
          ),
        ),
        title: Text(
          "Data List Kelas",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20.r),
          child: Center(
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20.w),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            Text(
              'List Kelas',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            SizedBox(height: 10.h),
            Expanded(
              child: FutureBuilder<List<Kelas>>(
                future: futureKelas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Terjadi kesalahan: ${snapshot.error}"),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                futureKelas = ApiService().fetchKelas();
                              });
                            },
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada data Kelas."));
                  }
                  List<Kelas> kelasList = snapshot.data!;
                  return ListView.builder(
                    itemCount: kelasList.length,
                    itemBuilder: (context, index) {
                      return KelasTile(kelas: kelasList[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class KelasTile extends StatelessWidget {
  final Kelas kelas;
  const KelasTile({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AbsensiDetail(
                id: kelas.id,
                namaKelas: kelas.nama,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 60.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              // Nama Kelas
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kelas.nama,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
