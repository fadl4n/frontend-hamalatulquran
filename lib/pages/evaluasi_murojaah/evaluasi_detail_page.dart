// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:frontend_hamalatulquran/models/histori_model.dart';
// import 'package:frontend_hamalatulquran/models/santri_model.dart';
// import 'package:frontend_hamalatulquran/services/setoran_service.dart';
// import 'package:frontend_hamalatulquran/services/snackbar_helper.dart';
// import 'package:frontend_hamalatulquran/widgets/content_section.dart';
// import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
// import 'package:frontend_hamalatulquran/widgets/header_evaluasi.dart';
// import 'package:frontend_hamalatulquran/widgets/input_nilai_murojaah.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EvaluasiDetailPage extends StatefulWidget {
//   final int idSurat;
//   final int idTarget;
//   final String namaSurat;
//   final int jumlahAyat;
//   final String persentase;
//   final Santri santri;

//   const EvaluasiDetailPage(
//       {super.key,
//       required this.idSurat,
//       required this.idTarget,
//       required this.namaSurat,
//       required this.jumlahAyat,
//       required this.persentase,
//       required this.santri});

//   @override
//   State<EvaluasiDetailPage> createState() => _EvaluasiDetailPageState();
// }

// class _EvaluasiDetailPageState extends State<EvaluasiDetailPage> {
//   List<Histori> nilaiMurojaahList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNilaiMurojaahList();
//   }

//   Future<void> fetchNilaiMurojaahList() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final result = await SetoranService.getSetoranSantriByTarget(
//         widget.santri.id,
//         widget.idTarget,
//       );

//       setState(() {
//         setoranHafalan = result.reversed.toList();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       SnackbarHelper.showError(context, 'Error: $e');
//       print("Error: $e");
//     }
//   }

//   void _showInputNilaiMurojaahForm(
//       {required String imageUrl, required String gender}) async {
//     final result = showDialog(
//       context: context,
//       builder: (context) => InputNilaiMurojaah(
//         namaSurat: widget.namaSurat,
//         santri: widget.santri,
//         imageUrl: imageUrl,
//         gender: gender,
//       ),
//     );
//     if (result == true) {
//       fetchSetoranHafalan();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade800,
//       appBar: CustomAppbar(
//           title: "Evaluasi Muroja'ah ${widget.namaSurat}", fontSize: 14.sp),
//       body: Column(
//         children: [
//           HeaderEvaluasi(
//             title: widget.namaSurat,
//             jumlahAyat: widget.jumlahAyat,
//             progres: widget.persentase,
//           ),
//           Expanded(child: _listEvaluasiSection()),
//         ],
//       ),
//     );
//   }

//   Widget _listEvaluasiSection() {
//     return ContentSection(
//       title: "Muroja'ah Hafalan",
//       itemCount: setoranHafalan.isEmpty ? 1 : setoranHafalan.length,
//       itemBuilder: (context, index) {
//         if (isLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (setoranHafalan.isEmpty) {
//           return Center(
//             child: Text(
//               "Tidak ada hafalan yang akan di muroja'ah",
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 color: Colors.black87,
//               ),
//             ),
//           );
//         }
//         return ListView.builder(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           itemCount: setoranHafalan.length,
//           itemBuilder: (context, index) {
//             final setoran = setoranHafalan[index];

//             return Card(
//               margin: EdgeInsets.only(bottom: 12.h),
//               child: Padding(
//                 padding: EdgeInsets.all(12.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Setoran ${index + 1}",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16.sp),
//                     ),
//                     SizedBox(height: 8.h),

//                     // Nilai awal
//                     if (setoran.nilai != null)
//                       Row(
//                         children: [
//                           Text("Nilai: ${setoran.nilai}"),
//                         ],
//                       )
//                     else
//                       ElevatedButton(
//                         onPressed: () {
//                           _showInputNilaiMurojaahForm(
//                             imageUrl: widget.santri.fotoSantri ?? '',
//                             gender: widget.santri.jenisKelamin,
//                           );
//                         },
//                         child: const Text("Input Nilai"),
//                       ),

//                     // Nilai Remedial
//                     if (setoran.nilaiRemed != null) ...[
//                       SizedBox(height: 4.h),
//                       Row(
//                         children: [
//                           Text(
//                             "Remedial: ${setoran.nilaiRemed}",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       )
//                     ]
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
