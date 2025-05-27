import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/histori_model.dart';
import 'input_nilai_murojaah/input_nilai_murojaah.dart';

class InputFieldsWidget extends StatelessWidget {
  final TextEditingController nilaiController;
  final TextEditingController remedialController;
  final Histori histori;
  final VoidCallback onNilaiChanged;
  final VoidCallback onRemedialChanged;

  const InputFieldsWidget({
    Key? key,
    required this.nilaiController,
    required this.remedialController,
    required this.histori,
    required this.onNilaiChanged,
    required this.onRemedialChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double nilaiSaatIni = double.tryParse(nilaiController.text) ?? 0;
    final bool hasExistingValue = histori.nilai != null && histori.nilai! > 0;
    final bool isInputMode = nilaiSaatIni == 0 || !hasExistingValue;
    final bool isRemedialMode = hasExistingValue && nilaiSaatIni < kkm;
    final bool isMurojaahMode = hasExistingValue && nilaiSaatIni >= kkm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nilai Utama
        _buildNilaiUtamaField(
          nilaiSaatIni: nilaiSaatIni,
          hasExistingValue: hasExistingValue,
          isInputMode: isInputMode,
        ),

        SizedBox(height: 16.h),

        // Conditional Fields berdasarkan mode
        if (isRemedialMode) ...[
          _buildRemedialField(),
          SizedBox(height: 8.h),
          _buildRemedialHelpText(),
        ] else if (isMurojaahMode) ...[
          _buildMurojaahSection(),
        ] else if (!isInputMode && nilaiSaatIni > 0 && nilaiSaatIni < kkm) ...[
          _buildRemedialField(),
          SizedBox(height: 8.h),
          _buildRemedialHelpText(),
        ],
      ],
    );
  }

  Widget _buildNilaiUtamaField({
    required double nilaiSaatIni,
    required bool hasExistingValue,
    required bool isInputMode,
  }) {
    return TextFormField(
      controller: nilaiController,
      keyboardType: TextInputType.number,
      readOnly: hasExistingValue,
      decoration: InputDecoration(
        labelText: hasExistingValue ? 'Nilai' : 'Nilai Utama',
        hintText: hasExistingValue ? null : 'Masukkan nilai (0-100)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color:
                hasExistingValue ? Colors.grey.shade300 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: hasExistingValue
                ? Colors.grey.shade300
                : nilaiSaatIni >= kkm
                    ? Colors.green
                    : Colors.orange,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(
          color: hasExistingValue
              ? Colors.grey.shade500
              : nilaiSaatIni >= kkm
                  ? Colors.green.shade600
                  : Colors.orange.shade600,
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        filled: hasExistingValue,
        fillColor: hasExistingValue ? Colors.grey.shade50 : null,
      ),
      style: GoogleFonts.poppins(
        color: hasExistingValue
            ? Colors.grey.shade600
            : nilaiSaatIni >= kkm
                ? Colors.green.shade700
                : Colors.orange.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      onChanged: hasExistingValue ? null : (val) => onNilaiChanged(),
    );
  }

  Widget _buildRemedialField() {
    return TextFormField(
      controller: remedialController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Nilai Remedial',
        hintText: 'Masukkan nilai remedial (0-100)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(
          color: Colors.blue.shade600,
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      style: GoogleFonts.poppins(
        color: Colors.blue.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      onChanged: (val) => onRemedialChanged(),
    );
  }

  Widget _buildRemedialHelpText() {
    return Text(
      'Remedial diperlukan karena nilai di bawah kkm',
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.orange.shade600,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildMurojaahSection() {
    if (histori.nilaiRemed != null) {
      return Column(
        children: [
          TextFormField(
            controller:
                TextEditingController(text: histori.nilaiRemed.toString()),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Nilai Remedial (Sebelumnya)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              labelStyle: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Alhamdulillah, nilai sudah memenuhi kkm',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.green.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Text(
          'Alhamdulillah, nilai sudah memenuhi kkm ✓',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.green.shade700,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
