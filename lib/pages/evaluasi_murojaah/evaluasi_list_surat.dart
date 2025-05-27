import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/widgets/forms/input_nilai_murojaah/input_nilai_murojaah.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/histori_model.dart';
import '../../models/santri_model.dart';
import '../../services/hafalan/histori_service.dart';
import '../../services/utils/snackbar_helper.dart';
import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/layout/content_section.dart';
import '../../widgets/layout/header_section.dart';
import '../../widgets/target_hafalan/target_hafalan_item.dart';

class EvaluasiListSurat extends StatefulWidget {
  final Santri santri;
  const EvaluasiListSurat({super.key, required this.santri});

  @override
  State<EvaluasiListSurat> createState() => _EvaluasiListSuratState();
}

class _EvaluasiListSuratState extends State<EvaluasiListSurat> {
  List<Histori> evaluasiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvaluasiList();
  }

  Future<void> fetchEvaluasiList() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result =
          await HistoriService.fetchHistoriBySantri(widget.santri.id);

      setState(() {
        evaluasiList = result;
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
          title: "Evaluasi Muroja'ah ${widget.santri.nama}", fontSize: 14.sp),
      body: Column(
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
      title: "Evaluasi Muroja'ah",
      itemCount: evaluasiList.isEmpty ? 1 : evaluasiList.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (evaluasiList.isEmpty) {
          return Center(
            child: Text(
              "Belum ada setoran hafalan yang akan di evaluasi 🥲",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          );
        }
        final item = evaluasiList[index];
        print(
            "PROGRES VALUE: ${item.persentase} (${item.persentase.runtimeType})");
        final persentase = double.tryParse(item.persentase) ?? 0.0;
        final bool isComplete = persentase == 100;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: TargetHafalanItem(
            hafalan: item,
            isDisable: !isComplete,
            onTap: () async {
              if (!isComplete) {
                SnackbarHelper.showInfo(context,
                    'Setoran hafalan ini belum selesai, nilai bisa diinput jika sudah 100%');
                return;
              }
              final result = await showInputNilaiDialog(context, item);
              if (result == true) {
                await fetchEvaluasiList(); // refresh ulang data dari API
              }
            },
          ),
        );
      },
    );
  }
}
