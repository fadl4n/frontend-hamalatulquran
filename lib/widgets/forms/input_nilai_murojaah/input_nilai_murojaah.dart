import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/widgets/forms/input_nilai_murojaah/action_button.dart';
import 'package:frontend_hamalatulquran/widgets/forms/input_nilai_murojaah/nilai_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/histori_model.dart';
import '../input_fields.dart';

const int kkm = 75;

Future<bool?> showInputNilaiDialog(BuildContext context, Histori histori) {
  final TextEditingController nilaiController = TextEditingController(
    text: histori.nilai?.toString() ?? '',
  );
  final TextEditingController remedialController = TextEditingController(
    text: histori.nilaiRemed?.toString() ?? '',
  );

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final int nilaiSaatIni = int.tryParse(nilaiController.text) ?? 0;
          final int nilaiRemedialSaatIni =
              int.tryParse(remedialController.text) ?? 0;
          final bool sudahAdaNilaiFinal =
              (histori.nilai != null && histori.nilai! >= kkm) ||
                  (histori.nilaiRemed != null && histori.nilaiRemed! >= kkm);
          final bool hasExistingValue =
              histori.nilai != null && histori.nilai! > 0;
          final bool isInputMode = nilaiSaatIni == 0 || !hasExistingValue;
          final bool isRemedialMode = hasExistingValue && nilaiSaatIni < kkm;
          final bool isMurojaahMode = hasExistingValue && sudahAdaNilaiFinal;

          String getDialogTitle() {
            if (isInputMode) return 'Input Nilai';
            if (isRemedialMode) return 'Remedial';
            if (isMurojaahMode) return 'Nilai Murojaah';
            return 'Input Nilai';
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24), // Balance the close button
                        Expanded(
                          child: Text(
                            getDialogTitle(),
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Preview Card
                    NilaiPreviewCard(
                      histori: histori,
                      nilaiSaatIni: nilaiSaatIni,
                      nilaiRemedialSaatIni: nilaiRemedialSaatIni,
                      isRemedialMode: isRemedialMode,
                      sudahAdaNilaiFinal: sudahAdaNilaiFinal,
                    ),
                    SizedBox(height: 20.h),

                    // Input Fields
                    // nanti di bagian UI, ganti:
                    !sudahAdaNilaiFinal
                        ? InputFieldsWidget(
                            nilaiController: nilaiController,
                            remedialController: remedialController,
                            histori: histori,
                            onNilaiChanged: () {
                              setState(() {});
                            },
                            onRemedialChanged: () {
                              setState(() {});
                            },
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 32.h),

                    // Action Buttons
                    NilaiActionButtons(
                      context: context,
                      histori: histori,
                      nilaiController: nilaiController,
                      remedialController: remedialController,
                      isInputMode: isInputMode,
                      isRemedialMode: isRemedialMode,
                      isMurojaahMode: isMurojaahMode,
                      sudahAdaNilaiFinal: sudahAdaNilaiFinal,
                      onSuccess: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
