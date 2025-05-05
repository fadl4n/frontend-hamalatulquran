import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/pages/evaluasi_murojaah/evaluasi_detail_page.dart';
import 'package:frontend_hamalatulquran/widgets/content_section.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/header_section.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluasiListSurat extends StatefulWidget {
  final Santri santri;
  const EvaluasiListSurat({super.key, required this.santri});

  @override
  State<EvaluasiListSurat> createState() => _EvaluasiListSuratState();
}

class _EvaluasiListSuratState extends State<EvaluasiListSurat> {
  bool isLoading = true;
  List<Map<String, dynamic>> murojaahList = [];

  @override
  void initState() {
    super.initState();
    fetchMurojaahList();
  }

  Future<void> fetchMurojaahList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      murojaahList = [
        {
          "id_surat": 1,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 100
        },
        {
          "id_surat": 2,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 100
        },
        {
          "id_surat": 3,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 60
        },
        {
          "id_surat": 4,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 92
        },
        {
          "id_surat": 5,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 85
        },
        {
          "id_surat": 6,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 100
        },
        {
          "id_surat": 7,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 53
        },
        {
          "id_surat": 8,
          "surat": "Al-Fatihah",
          "arti": "Pembuka",
          "jumlah_ayat": 7,
          "progres": 90
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
          title: "Evaluasi Muroja'ah ${widget.santri.nama}", fontSize: 14.sp),
      body: Column(
        children: [
          _headerSection(),
          Expanded(child: _listHafalanSection()),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return HeaderSection(
      title: widget.santri.nama,
      nisn: widget.santri.nisn,
      kelasSantri: widget.santri.kelasNama,
    );
  }

  Widget _listHafalanSection() {
    return ContentSection(
      title: "Evaluasi Muroja'ah",
      itemCount: murojaahList.length,
      itemBuilder: (context, index) {
        final item = murojaahList[index];
        print(
            "PROGRES VALUE: ${item['progres']} (${item['progres'].runtimeType})");

        // Logic warna progres
        Color percentColor = item['progres'] >= 85
            ? Colors.green
            : item['progres'] >= 70
                ? Colors.orange
                : Colors.red;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EvaluasiDetailPage(
                  idSurat: item['id_surat'],
                  namaSurat: item['surat'],
                  jumlahAyat: item['jumlah_ayat'],
                  status: item['progres'],
                  santri: widget.santri
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 👉 Kiri: info surat
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['surat'],
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Arti: ${item['arti']}",
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "Jumlah Ayat: ${item['jumlah_ayat']} ayat",
                        style: GoogleFonts.poppins(fontSize: 13.sp),
                      ),
                    ],
                  ),
                  // 👉 Kanan: progres + icon
                  Row(
                    children: [
                      Text(
                        "${item['progres']}%",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: percentColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
