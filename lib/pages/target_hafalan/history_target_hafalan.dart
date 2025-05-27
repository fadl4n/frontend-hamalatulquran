import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/setoran_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/hafalan/setoran_service.dart';
import '../../services/utils/formatter.dart';
import '../../services/utils/snackbar_helper.dart';
import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/forms/input_setoran_form.dart';
import '../../widgets/layout/content_section.dart';
import '../../widgets/layout/header_evaluasi.dart';
import '../../widgets/timeline/hafalan_time_line.dart';

class HistoryTargetHafalan extends StatefulWidget {
  final Santri santri;
  final int idTarget;
  final int idSurat;
  final String namaSurat;
  final int jumlahAyat;
  final String targetAyat;
  final int ayatTargetAkhir;

  final bool hideFAB;

  const HistoryTargetHafalan({
    super.key,
    required this.santri,
    required this.idTarget,
    required this.idSurat,
    required this.namaSurat,
    required this.jumlahAyat,
    required this.targetAyat,
    required this.ayatTargetAkhir,
    this.hideFAB = false,
  });

  @override
  State<HistoryTargetHafalan> createState() => _HistoryTargetHafalanState();
}

class _HistoryTargetHafalanState extends State<HistoryTargetHafalan> {
  List<Setoran> setoranHafalan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSetoranHafalan();
  }

  Future<void> fetchSetoranHafalan() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await SetoranService.getSetoranSantriByTarget(
        widget.santri.id,
        widget.idTarget,
      );

      setState(() {
        setoranHafalan = result.reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackbarHelper.showError(context, 'Error: $e');
      print("Error: $e");
    }
  }

  Future<void> _showInputHafalanForm({
    required String imageUrl,
    required String gender,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => InputSetoranForm(
        idTarget: widget.idTarget,
        idSurat: widget.idSurat,
        santri: widget.santri,
        surat: widget.namaSurat,
        targetAyat: widget.targetAyat,
        imageUrl: imageUrl,
        gender: gender,
      ),
    );
    // Refresh data kalau hasilnya bukan null
    if (result == true) {
      await fetchSetoranHafalan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade800,
        appBar: CustomAppbar(title: "Target Hafalan", fontSize: 18.sp),
        body: Column(
          children: [
            HeaderEvaluasi(
                title: widget.namaSurat,
                jumlahAyat: widget.jumlahAyat,
                targetAyat: widget.targetAyat),
            Expanded(child: _historySection()),
          ],
        ),
        floatingActionButton: widget.hideFAB
            ? null // ini bakal ngilangin FAB kalo true
            : FloatingActionButton(
                onPressed: () async {
                  await _showInputHafalanForm(
                    imageUrl: widget.santri.fotoSantri ?? '',
                    gender: widget.santri.jenisKelamin,
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white),
              ),
      ),
    );
  }

  Widget _historySection() {
    return ContentSection(
      title: 'History Hafalan',
      itemCount: setoranHafalan.isEmpty ? 1 : setoranHafalan.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (setoranHafalan.isEmpty) {
          return Center(
            child: Text(
              "Belum ada Setoran Hafalan 🥲",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          );
        }
        final setoran = setoranHafalan[index];
        return HafalanTimeline(
          surah: "Surat ${widget.namaSurat}",
          ayat: "Ayat ${setoran.ayat}",
          ustadz: formatNamaPengajar(
              setoran.pengajar, setoran.jenisKelaminPengajar),
          tanggal: formatTanggal(setoran.tanggal),
          isFirst: index == 0,
          isLast: index == setoranHafalan.length - 1,
        );
      },
    );
  }
}
