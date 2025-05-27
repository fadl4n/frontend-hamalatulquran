import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/services/api/absensi/absensi_service.dart';
import 'package:frontend_hamalatulquran/services/api/api_service.dart';
import 'package:frontend_hamalatulquran/services/utils/snackbar_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/santri_model.dart';

class AbsensiStatus {
  final Santri santri;
  int? status;
  final List<Map<String, dynamic>> opsiStatusAbsen = [
    {'value': 1, 'label': 'Hadir'},
    {'value': 2, 'label': 'Sakit'},
    {'value': 3, 'label': 'Izin'},
    {'value': 4, 'label': 'Alpa'},
  ];

  AbsensiStatus({required this.santri, this.status});
}

String getStatusLabel(int? status) {
  switch (status) {
    case 1:
      return 'Hadir';
    case 2:
      return 'Sakit';
    case 3:
      return 'Izin';
    case 4:
      return 'Alfa';
    default:
      return '-';
  }
}

Future<bool?> showAbsensiDialog(BuildContext context, int idKelas, String namaKelas) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return FutureBuilder<List<Santri>>(
        future: ApiService().fetchSantriByKelas(idKelas),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Gagal load data santri."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tutup"),
                ),
              ],
            );
          }

          final santriList = snapshot.data ?? [];
          List<AbsensiStatus> absensiData =
              santriList.map((s) => AbsensiStatus(santri: s)).toList();

          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                color: Colors.white,
                child: StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.r)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Rekap Absensi",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.green.shade700,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                children: [
                                  Text(
                                    "Kelas $namaKelas",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Jumlah Santri: ${santriList.length}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    DateFormat("EEEE, dd MMMM yyyy", 'id_ID')
                                        .format(DateTime.now()),
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(4),
                                    2: FlexColumnWidth(3),
                                  },
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.shade400),
                                    outside: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  ),
                                  children: [
                                    // HEADER
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade300),
                                      children: const [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Center(
                                            child: Text(
                                              'NISN',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Center(
                                            child: Text(
                                              'Nama',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Center(
                                            child: Text(
                                              'Kehadiran',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ISI TABEL
                                    for (int i = 0; i < absensiData.length; i++)
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: i % 2 == 0
                                              ? Colors.green.shade50
                                              : Colors.green.shade100,
                                        ),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                            ),
                                            child: Container(
                                              height: 70.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                absensiData[i].santri.nisn,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.nunito(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                            ),
                                            child: Container(
                                              height: 70.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  absensiData[i].santri.nama,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                                vertical: 10.h),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: DropdownButton<int>(
                                                value: absensiData[i].status,
                                                isExpanded: false,
                                                hint: Text("Pilih"),
                                                underline: SizedBox(),
                                                onChanged: (value) {
                                                  absensiData[i].status = value;
                                                  (context as Element)
                                                      .markNeedsBuild(); // biar rebuild dropwdown-nya
                                                },
                                                items: absensiData[i]
                                                    .opsiStatusAbsen
                                                    .map<DropdownMenuItem<int>>(
                                                        (opsi) {
                                                  return DropdownMenuItem<int>(
                                                    value: opsi['value'],
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          opsi['label'],
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () async {
                                        // TODO: Simpan absensi ke API
                                        final tanggal = DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());

                                        final dataAbsensi = absensiData
                                            .map((e) => {
                                                  'id_kelas': e.santri.idKelas,
                                                  'id_santri': e.santri.id,
                                                  'nisn': e.santri.nisn,
                                                  'status': e.status ??
                                                      0, // defaultin kalau belum dipilih
                                                })
                                            .toList();

                                        final success =
                                            await AbsensiService.simpanAbsensi(
                                          tanggal: tanggal,
                                          data: dataAbsensi,
                                        );

                                        if (success) {
                                          Navigator.pop(context, true);
                                          SnackbarHelper.showSuccess(context,
                                              "Absensi berhasil disimpan!");
                                        } else {
                                          SnackbarHelper.showError(context,
                                              "Gagal menyimpan absensi.");
                                        }
                                      },
                                      child: Text("Simpan"),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Batal"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}
