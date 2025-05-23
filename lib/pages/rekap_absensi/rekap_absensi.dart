import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/repositories/kelas_repository.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/pages/rekap_absensi/absensi_detail.dart';
import 'package:frontend_hamalatulquran/models/kelas_model.dart';

import '../../widgets/tiles/kelas_tile.dart';

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
    futureKelas = KelasRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Rekap Absensi", fontSize: 18.sp),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
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
                                futureKelas = KelasRepository.getAll();
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
                      final kelas = kelasList[index];
                      return KelasTile(
                        kelas: kelas,
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
                      );
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