import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/target_hafalan_model.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/history_target_hafalan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/hafalan/target_service.dart';
import '../../services/utils/snackbar_helper.dart';
import '../../widgets/layout/content_section.dart';
import '../../widgets/layout/header_section.dart';
import '../../widgets/target_hafalan/target_hafalan_item.dart';

class TargetHafalanSantri extends StatefulWidget {
  final Santri santri;

  const TargetHafalanSantri({
    super.key,
    required this.santri,
  });

  @override
  State<TargetHafalanSantri> createState() => _TargetHafalanSantriState();
}

class _TargetHafalanSantriState extends State<TargetHafalanSantri> {
  List<TargetHafalan> targetHafalan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTargetHafalan();
  }

  Future<void> fetchTargetHafalan() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await TargetService.fetchAllTargetBySantri(
        widget.santri.id.toString(),
      );

      setState(() {
        targetHafalan = result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
        title: "Target Hafalan ${widget.santri.nama}",
        fontSize: 15.sp,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                HeaderSection(
                  title: widget.santri.nama,
                  nisn: widget.santri.nisn,
                  kelasSantri: widget.santri.kelasNama,
                ),
                Expanded(child: _listHafalanSection()),
              ],
            ),
    );
  }

  Widget _listHafalanSection() {
    return ContentSection(
      title: "Target Hafalan",
      itemCount: targetHafalan.isEmpty ? 1 : targetHafalan.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (targetHafalan.isEmpty) {
          return Center(
            child: Text(
              "Belum ada target hafalan 🥲",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          );
        }
        final hafalan = targetHafalan[index];
        // Logic warna progres
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: TargetHafalanItem(
            hafalan: hafalan,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryTargetHafalan(
                      santri: widget.santri,
                      idTarget: hafalan.idTarget,
                      idSurat: hafalan.idSurat,
                      namaSurat: hafalan.namaSurat,
                      jumlahAyat: hafalan.jumlahAyat,
                      targetAyat: '${hafalan.ayatAwal} - ${hafalan.ayatAkhir}',
                      ayatTargetAkhir: hafalan.ayatAkhir),
                ),
              );
              if (result == true) {
                await fetchTargetHafalan();
              }
            },
          ),
        );
      },
    );
  }
}
