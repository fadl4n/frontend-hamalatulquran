import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/services/form_helper.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/header_evaluasi.dart';
import 'package:frontend_hamalatulquran/widgets/profile_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class HistoryTargetHafalan extends StatefulWidget {
  final String namaSurat;
  final int jumlahAyat;
  final Santri santri;

  const HistoryTargetHafalan(
      {super.key,
      required this.namaSurat,
      required this.jumlahAyat,
      required this.santri});

  @override
  State<HistoryTargetHafalan> createState() => _HistoryTargetHafalanState();
}

class _HistoryTargetHafalanState extends State<HistoryTargetHafalan> {
  List<Map<String, String>> historyHafalan = [
    {
      'ayat': '1-3',
      'ustadz': 'Ustzh. Rizka',
      'tanggal': '5/2/2025',
      'waktu': '17:14'
    },
  ];

  void _showInputHafalanForm(
      {required String imageUrl, required String gender}) {
    print("Nama Surat: ${widget.namaSurat}"); // Debugging

    TextEditingController suratController =
        TextEditingController(text: widget.namaSurat);
    TextEditingController ayatAwalController = TextEditingController();
    TextEditingController ayatAkhirController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300.w),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.santri.nama,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          widget.santri.nisn,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Surat (Non-editable)
                        buildLabel("Surat"),
                        buildTextField("Surat",
                            controller: suratController, readOnly: true),

                        SizedBox(height: 20.h),

                        // Ayat Awal
                        buildLabel("Ayat Awal"),
                        buildTextField("Input Ayat Awal",
                            controller: ayatAwalController),

                        SizedBox(height: 20.h),

                        // Ayat Akhir
                        buildLabel("Ayat Akhir"),
                        buildTextField("Input Ayat Akhir",
                            controller: ayatAkhirController),

                        SizedBox(height: 25.h),

                        // Tombol Simpan & Batal
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print(
                                      "Ayat Awal: ${ayatAwalController.text}");
                                  print(
                                      "Ayat Akhir: ${ayatAkhirController.text}");
                                  String ayatAwal =
                                      ayatAwalController.text.trim();
                                  String ayatAkhir =
                                      ayatAkhirController.text.trim();

                                  if (ayatAwal.isNotEmpty &&
                                      ayatAkhir.isNotEmpty) {
                                    setState(() {
                                      historyHafalan.insert(0, {
                                        'ayat': '$ayatAwal - $ayatAkhir',
                                        'ustadz': 'Ustadzah Rizka',
                                        'tanggal': DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now()),
                                        'waktu': DateFormat('HH:mm')
                                            .format(DateTime.now()),
                                      });
                                    });

                                    Navigator.pop(context);
                                  } else {
                                    print(
                                        "Error: Ayat Awal atau Ayat Akhir masih kosong");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  "Simpan",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 40.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  "Batal",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Avatar di luar card
                  // Ganti bagian ini:
                  Positioned(
                    top: -55.h,
                    child: ProfileAvatar(
                      imageUrl: imageUrl, // Pastikan ini ada di widget-mu
                      gender: gender, // Pastikan ini juga ada
                      size: 110, // Karena radius sebelumnya 55.r
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(title: "Target Hafalan", fontSize: 18.sp),
      body: Column(
        children: [
          HeaderEvaluasi(
            title: widget.namaSurat,
            jumlahAyat: widget.jumlahAyat,
          ),
          Expanded(child: _historySection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputHafalanForm(
          imageUrl: widget.santri.fotoSantri ?? '',
          gender: widget.santri.jenisKelamin,
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _historySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "History",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: historyHafalan.length,
                itemBuilder: (context, index) {
                  var history = historyHafalan[index];
                  return TimelineTile(
                    alignment: TimelineAlign.start,
                    isFirst: index == 0,
                    isLast: index == historyHafalan.length - 1,
                    beforeLineStyle:
                        const LineStyle(color: Colors.grey, thickness: 3),
                    afterLineStyle:
                        const LineStyle(color: Colors.grey, thickness: 3),
                    indicatorStyle: IndicatorStyle(
                      width: 10.w,
                      color: Colors.grey,
                      indicatorXY: 0.2,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                    ),
                    endChild: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Surat ${widget.namaSurat}",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Ayat ${history['ayat']}",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              history['ustadz']!,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "${history['tanggal']}  ${history['waktu']}",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
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
