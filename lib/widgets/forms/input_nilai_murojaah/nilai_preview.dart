import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/histori_model.dart';
import 'input_nilai_murojaah.dart';

class NilaiPreviewCard extends StatelessWidget {
  final Histori histori;
  final int nilaiSaatIni;
  final int nilaiRemedialSaatIni;
  final bool isRemedialMode;
  final bool sudahAdaNilaiFinal;

  const NilaiPreviewCard({
    super.key,
    required this.histori,
    required this.nilaiSaatIni,
    required this.nilaiRemedialSaatIni,
    required this.isRemedialMode,
    required this.sudahAdaNilaiFinal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _nilaiBox(nilaiSaatIni, nilaiSaatIni >= kkm
                  ? Colors.green.shade100
                  : nilaiSaatIni > 0
                      ? Colors.orange.shade100
                      : Colors.grey.shade100,
                  nilaiSaatIni >= kkm
                      ? Colors.green.shade600
                      : nilaiSaatIni > 0
                          ? Colors.orange.shade600
                          : Colors.grey.shade600),
              if (isRemedialMode && nilaiRemedialSaatIni > 0) ...[
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward, size: 16.sp, color: Colors.grey.shade400),
                SizedBox(width: 8.w),
                _nilaiBox(nilaiRemedialSaatIni, nilaiRemedialSaatIni >= kkm
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
                    nilaiRemedialSaatIni >= kkm
                        ? Colors.green.shade600
                        : Colors.blue.shade600,
                    border: Border.all(color: Colors.blue.shade300, width: 1.5)),
              ]
            ],
          ),
          SizedBox(height: 8.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(histori.namaSurat,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )),
              Text(
                nilaiSaatIni >= kkm || nilaiRemedialSaatIni >= kkm
                    ? '✓ Lulus'
                    : nilaiSaatIni > 0
                        ? 'Perlu Remedial'
                        : 'Belum dinilai',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: sudahAdaNilaiFinal
                      ? Colors.green.shade600
                      : nilaiSaatIni > 0
                          ? Colors.orange.shade600
                          : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nilaiBox(int value, Color bgColor, Color textColor, {BoxBorder? border}) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: border,
      ),
      child: Center(
        child: Text(
          value > 0 ? value.toString() : '?',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
