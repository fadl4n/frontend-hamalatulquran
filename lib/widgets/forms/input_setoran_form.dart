import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api/api_exception.dart';
import '../../services/api/api_service.dart';
import '../../services/hafalan/setoran_service.dart';
import '../../services/utils/form_helper.dart';
import '../../services/utils/snackbar_helper.dart';
import '../profile_components/profile_avatar.dart';

class InputSetoranForm extends StatefulWidget {
  final Santri santri;
  final String surat;
  final int idTarget;
  final int idSurat;
  final String targetAyat;
  final String imageUrl;
  final String gender;
  const InputSetoranForm({
    super.key,
    required this.santri,
    required this.idTarget,
    required this.idSurat,
    required this.surat,
    required this.targetAyat,
    required this.imageUrl,
    required this.gender,
  });

  @override
  State<InputSetoranForm> createState() => _InputSetoranFormState();
}

class _InputSetoranFormState extends State<InputSetoranForm> {
  final TextEditingController ayatAwalController = TextEditingController();
  final TextEditingController ayatAkhirController = TextEditingController();
  final TextEditingController tanggalSetoranController =
      TextEditingController();
  final TextEditingController nilaiController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  List<Pengajar> pengajarList = [];
  Pengajar? selectedPengajar;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    ayatAwalController.dispose();
    ayatAkhirController.dispose();
    tanggalSetoranController.dispose();
    nilaiController.dispose(); // ini belum
    keteranganController.dispose(); // ini juga
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPengajarList();
  }

  Future<void> _loadPengajarList() async {
    try {
      final data = await ApiService.fetchPengajar();
      setState(() {
        pengajarList = data;
      });
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        SnackbarHelper.showError(context, "Gagal memuat pengajar");
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Prevent multiple submissions
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ayatAwal = int.parse(ayatAwalController.text);
      final ayatAkhir = int.parse(ayatAkhirController.text);
      final tanggalSetoran = tanggalSetoranController.text;
      final pengajarId = selectedPengajar?.id;

      if (pengajarId == null) {
        SnackbarHelper.showError(context, "Pengajar belum dipilih");
        return;
      }

      // Buat payload data yang mau dikirim
      final payload = {
        "id_target": widget.idTarget,
        "id_santri": widget.santri.id,
        "id_kelas": widget.santri.idKelas,
        "id_surat": widget.idSurat,
        "id_pengajar": pengajarId,
        "jumlah_ayat_start": ayatAwal,
        "jumlah_ayat_end": ayatAkhir,
        "tgl_setoran": tanggalSetoran,
        "nilai": int.tryParse(nilaiController.text),
        "keterangan": keteranganController.text,
      };

      print("Payload yang akan dikirim: $payload");

      // Kirim ke API
      await SetoranService.createSetoran(payload);

      // Kalau sukses, tutup dialog dan kasih feedback
      Future.microtask(() {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context, true);
          SnackbarHelper.showSuccess(context, "Setoran berhasil disimpan!");
        }
      });
    } catch (e) {
      print("Error submit setoran: $e");
      String errorMess = "Gagal Menyimpan Setoran";

      if (e is ApiException) {
        errorMess = e.message;
      }

      if (mounted) {
        SnackbarHelper.showError(context, errorMess);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
                child: Form(
                  // Wrap everything in a Form widget
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    // Added ScrollView to prevent overflow
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.surat,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          widget.targetAyat,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        buildLabel("Ustadz/Ustadzah"),
                        DropdownButtonFormField<Pengajar>(
                          value: selectedPengajar,
                          decoration: InputDecoration(
                            hintText: "Ustadz/Ustadzah",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                          ),
                          items: pengajarList.map((pengajar) {
                            return DropdownMenuItem<Pengajar>(
                              value: pengajar,
                              child: Text(pengajar.nama),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPengajar = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Silakan pilih pengajar';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Ayat Awal dan Ayat Akhir
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildLabel("Ayat Awal"),
                                  buildTextField("Input Ayat Awal",
                                      controller: ayatAwalController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field ini wajib diisi';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Masukkan angka yang valid';
                                    }
                                    return null;
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildLabel("Ayat Akhir"),
                                  buildTextField("Input Ayat Akhir",
                                      controller: ayatAkhirController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field ini wajib diisi';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Masukkan angka yang valid';
                                    }
                                    final ayatAwal =
                                        int.tryParse(ayatAwalController.text);
                                    final ayatAkhir = int.tryParse(value);
                                    if (ayatAwal != null &&
                                        ayatAkhir != null &&
                                        ayatAkhir < ayatAwal) {
                                      return 'Ayat akhir harus lebih besar';
                                    }
                                    return null;
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Tanggal Setoran
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("Tanggal Setoran"),
                            GestureDetector(
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (selectedDate != null) {
                                  setState(() {
                                    tanggalSetoranController.text =
                                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                  child: buildTextField("Masukkan Tanggal",
                                      controller: tanggalSetoranController)),
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        buildLabel("Nilai Setoran"),
                        buildTextField("Masukkan nilai (0-100)",
                            controller: nilaiController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Nilai wajib diisi';
                          final n = int.tryParse(value);
                          if (n == null || n < 0 || n > 100)
                            return 'Nilai harus 0-100';
                          return null;
                        }),

                        SizedBox(height: 20.h),
                        buildLabel("Keterangan"),
                        buildTextField(
                          "Keterangan (opsional)",
                          controller: keteranganController,
                          validator: (value) => null,
                        ),

                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.w,
                                        ),
                                      )
                                    : Text(
                                        "Simpan",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(width: 25.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Future.microtask(() {
                                          if (mounted &&
                                              Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      },
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
