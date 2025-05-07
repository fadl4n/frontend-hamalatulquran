import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/widgets/content_section.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/hafalan_time_line.dart';
import 'package:frontend_hamalatulquran/widgets/header_evaluasi.dart';
import 'package:frontend_hamalatulquran/widgets/input_hafalan_form.dart';
import 'package:frontend_hamalatulquran/widgets/profile_avatar.dart';
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
    print("Nama Surat: ${widget.namaSurat}");

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
                    child: InputHafalanForm(
                      suratController: suratController,
                      ayatAwalController: ayatAwalController,
                      ayatAkhirController: ayatAkhirController,
                      onSave: (ayatAwal, ayatAkhir) {
                        setState(() {
                          historyHafalan.insert(0, {
                            'ayat': '$ayatAwal - $ayatAkhir',
                            'ustadz': 'Ustadzah Rizka',
                            'tanggal':
                                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            'waktu': DateFormat('HH:mm').format(DateTime.now()),
                          });
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: -55.h,
                    child: ProfileAvatar(
                      imageUrl: imageUrl,
                      gender: gender,
                      size: 110,
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
    return ContentSection(
      title: 'History Hafalan',
      itemCount: historyHafalan.length,
      itemBuilder: (context, index) {
        var history = historyHafalan[index];
        return HafalanTimeline(
          surah: "Surat ${history['surat']}",
          ayat: "Ayat ${history['ayat']}",
          ustadz: history['ustadz']!,
          tanggal: history['tanggal']!,
          waktu: history['waktu']!,
        );
      },
    );
  }
}
