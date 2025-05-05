import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/widgets/content_section.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/header_evaluasi.dart';
import 'package:frontend_hamalatulquran/widgets/input_evaluasi_form.dart';

class EvaluasiDetailPage extends StatefulWidget {
  final int idSurat;
  final String namaSurat;
  final int jumlahAyat;
  final int status;
  final Santri santri;

  const EvaluasiDetailPage(
      {super.key,
      required this.idSurat,
      required this.namaSurat,
      required this.jumlahAyat,
      required this.status,
      required this.santri});

  @override
  State<EvaluasiDetailPage> createState() => _EvaluasiDetailPageState();
}

class _EvaluasiDetailPageState extends State<EvaluasiDetailPage> {
  void _showInputEvaluasiForm(
      {required String imageUrl, required String gender}) {
    showDialog(
        context: context,
        builder: (context) => InputEvaluasiDialog(
              namaSurat: widget.namaSurat,
              santri: widget.santri,
              imageUrl: imageUrl,
              gender: gender,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
          title: "Evaluasi Muroja'ah ${widget.namaSurat}", fontSize: 14.sp),
      body: Column(
        children: [
          HeaderEvaluasi(
            title: widget.namaSurat,
            jumlahAyat: widget.jumlahAyat,
            progres: widget.status,
          ),
          Expanded(
            child: ContentSection(
              title: "Evaluasi Muroja'ah",
              itemCount: 0,
              itemBuilder: (context, index) {
                return SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputEvaluasiForm(
          imageUrl: widget.santri.fotoSantri ?? '',
          gender: widget.santri.jenisKelamin,
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
