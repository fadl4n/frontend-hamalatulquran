import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/histori_model.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/hafalan/histori_service.dart';
import '../../services/utils/snackbar_helper.dart';
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
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: TargetHafalanItem(
            hafalan: item,
            onTap: () async {
            },
          ),
        );
        // Logic warna progres
        // double persentaseValue = double.tryParse(item.persentase) ?? 0.0;

        // Color percentColor = persentaseValue >= 85
        //     ? Colors.green
        //     : persentaseValue >= 70
        //         ? Colors.orange
        //         : Colors.red;

        // return GestureDetector(
        //   onTap: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => EvaluasiDetailPage(
        //     //         idSurat: item.idHistori,
        //     //         idTarget: item.idTarget,
        //     //         namaSurat: item.namaSurat,
        //     //         jumlahAyat: item.jumlahAyat,
        //     //         persentase: item.persentase,
        //     //         santri: widget.santri),
        //     //   ),
        //     // );
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.only(bottom: 10.h),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        //       decoration: BoxDecoration(
        //         color: Colors.green.shade50,
        //         borderRadius: BorderRadius.circular(12.r),
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           // 👉 Kiri: info surat
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 item.namaSurat,
        //                 style: GoogleFonts.poppins(
        //                   fontSize: 16.sp,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               Text(
        //                 "Jumlah Ayat: ${item.jumlahAyat} ayat",
        //                 style: GoogleFonts.poppins(fontSize: 13.sp),
        //               ),
        //             ],
        //           ),
        //           // 👉 Kanan: progres + icon
        //           Row(
        //             children: [
        //               SizedBox(
        //                 width: 80.w,
        //                 child: CircularPercentIndicator(
        //                   radius: 40.0,
        //                   lineWidth: 10.0,
        //                   percent: persentaseValue / 100,
        //                   center: Text("${item.persentase}%",
        //                       style: GoogleFonts.poppins(
        //                           fontWeight: FontWeight.bold)),
        //                   progressColor: percentColor,
        //                   backgroundColor: Colors.grey.shade300,
        //                   animation: true,
        //                 ),
        //               ),
        //               SizedBox(width: 8.w),
        //               Icon(
        //                 Icons.arrow_forward_ios,
        //                 color: Colors.grey,
        //                 size: 16.w,
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
