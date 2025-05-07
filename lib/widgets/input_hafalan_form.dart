import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/services/form_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class InputHafalanForm extends StatelessWidget {
  final TextEditingController suratController;
  final TextEditingController ayatAwalController;
  final TextEditingController ayatAkhirController;
  final Function onSave;

  const InputHafalanForm({
    Key? key,
    required this.suratController,
    required this.ayatAwalController,
    required this.ayatAkhirController,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildLabel("Surat"),
        buildTextField("Surat", controller: suratController, readOnly: true),
        SizedBox(height: 20.h),
        buildLabel("Ayat Awal"),
        buildTextField("Input Ayat Awal", controller: ayatAwalController),
        SizedBox(height: 20.h),
        buildLabel("Ayat Akhir"),
        buildTextField("Input Ayat Akhir", controller: ayatAkhirController),
        SizedBox(height: 25.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  String ayatAwal = ayatAwalController.text.trim();
                  String ayatAkhir = ayatAkhirController.text.trim();
                  if (ayatAwal.isNotEmpty && ayatAkhir.isNotEmpty) {
                    onSave(ayatAwal, ayatAkhir);
                    Navigator.pop(context);
                  } else {
                    print("Error: Ayat Awal atau Ayat Akhir masih kosong");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Simpan",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 40.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Batal",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
