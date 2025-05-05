import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/services/form_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/widgets/profile_avatar.dart';

class InputEvaluasiDialog extends StatefulWidget {
  final String namaSurat;
  final Santri santri;
  final String imageUrl;
  final String gender;

  const InputEvaluasiDialog({
    super.key,
    required this.namaSurat,
    required this.santri,
    required this.imageUrl,
    required this.gender,
  });

  @override
  State<InputEvaluasiDialog> createState() => _InputEvaluasiDialogState();
}

class _InputEvaluasiDialogState extends State<InputEvaluasiDialog> {
  final TextEditingController suratController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController nilaiController = TextEditingController();
  int? selectedStatus;

  @override
  void initState() {
    super.initState();
    suratController.text = widget.namaSurat;
  }

  final Map<int, String> statusOptions = {
    0: "Belum Lancar",
    1: "Lancar",
    2: "Perlu Perbaikan", // contoh tambahan
  };

  @override
  void dispose() {
    suratController.dispose();
    catatanController.dispose();
    nilaiController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    String catatan = catatanController.text.trim();
    String nilaiText = nilaiController.text.trim();

    if (catatan.isEmpty || nilaiText.isEmpty || selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    final nilai = int.tryParse(nilaiText);
    if (nilai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai harus berupa angka")),
      );
      return;
    }

    // Di sinilah kamu bisa panggil service/API
    print("Evaluasi untuk ${widget.santri.nama}");
    print("Surat: ${widget.namaSurat}");
    print("Catatan: $catatan");
    print("Nilai: $nilai");
    print("Status: $selectedStatus - ${statusOptions[selectedStatus]}");

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Evaluasi berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300.w),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.santri.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.santri.nisn,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildLabel("Surat"),
                    buildTextField("Surat",
                        controller: suratController, readOnly: true),
                    SizedBox(height: 20.h),
                    buildLabel("Catatan"),
                    buildTextField("Masukan Catatan",
                        controller: catatanController),
                    SizedBox(height: 20.h),
                    buildLabel("Nilai"),
                    buildTextField("Masukkan Nilai",
                        controller: nilaiController),
                    SizedBox(height: 20.h),
                    buildLabel("Status"),
                    DropdownButtonFormField(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        hintText: "Pilih Status",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                      ),
                      items: statusOptions.entries
                          .map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
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
                                fontWeight: FontWeight.bold,
                              ),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -55.h,
                child: ProfileAvatar(
                  imageUrl: widget.imageUrl,
                  gender: widget.gender,
                  size: 110,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
