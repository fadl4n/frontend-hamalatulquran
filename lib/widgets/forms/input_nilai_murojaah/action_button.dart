import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/histori_model.dart';
import '../../../services/hafalan/histori_service.dart';
import '../../../services/utils/snackbar_helper.dart';
import 'input_nilai_murojaah.dart';

class NilaiActionButtons extends StatelessWidget {
  final BuildContext context;
  final Histori histori;
  final TextEditingController nilaiController;
  final TextEditingController remedialController;
  final bool isInputMode;
  final bool isRemedialMode;
  final bool isMurojaahMode;
  final bool sudahAdaNilaiFinal;
  final VoidCallback onSuccess;

  const NilaiActionButtons({
    super.key,
    required this.context,
    required this.histori,
    required this.nilaiController,
    required this.remedialController,
    required this.isInputMode,
    required this.isRemedialMode,
    required this.isMurojaahMode,
    required this.sudahAdaNilaiFinal,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isMurojaahMode
                ? null
                : () async {
                    final nilaiBaru = int.tryParse(nilaiController.text);
                    final nilaiRemedialBaru = int.tryParse(remedialController.text);

                    if (nilaiBaru == null || nilaiBaru < 0 || nilaiBaru > 100) {
                      SnackbarHelper.showError(context, "Nilai harus antara 0 - 100");
                      return;
                    }

                    if (nilaiBaru < kkm &&
                        (nilaiRemedialBaru == null ||
                            nilaiRemedialBaru < 0 ||
                            nilaiRemedialBaru > 100)) {
                      SnackbarHelper.showError(
                          context, "Nilai remedial harus valid (0 - 100)");
                      return;
                    }

                    final success = await HistoriService().updateNilaiMurojaah(
                      histori.idHistori,
                      nilaiBaru,
                      nilaiRemedial: nilaiBaru < kkm ? nilaiRemedialBaru : null,
                    );

                    if (success) {
                      onSuccess();
                      SnackbarHelper.showSuccess(
                        context,
                        isInputMode
                            ? "Nilai berhasil disimpan"
                            : isRemedialMode
                                ? "Nilai remedial berhasil disimpan"
                                : "Nilai berhasil diperbarui",
                      );
                    } else {
                      SnackbarHelper.showError(context, "Gagal menyimpan nilai, coba lagi");
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isMurojaahMode
                  ? Colors.grey.shade300
                  : sudahAdaNilaiFinal
                      ? Colors.green
                      : Colors.orange,
              foregroundColor:
                  isMurojaahMode ? Colors.grey.shade500 : Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              isMurojaahMode
                  ? 'Sudah Selesai'
                  : isInputMode
                      ? 'Simpan'
                      : isRemedialMode
                          ? 'Simpan Remedial'
                          : 'Perbarui',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
