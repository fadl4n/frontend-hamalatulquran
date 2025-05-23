import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/surat_model.dart';
import 'package:frontend_hamalatulquran/models/target_hafalan_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/api/api_exception.dart';
import '../../services/api/api_service.dart';
import '../../services/hafalan/target_service.dart';
import '../../services/quran/surat_service.dart';
import '../../services/utils/form_helper.dart';
import '../../services/utils/formatter.dart';
import '../../services/utils/snackbar_helper.dart';
import '../profile_components/profile_avatar.dart';

class EditTargetForm extends StatefulWidget {
  final Santri santri;
  final String imageUrl;
  final String gender;
  final TargetHafalan target;
  const EditTargetForm({
    super.key,
    required this.santri,
    required this.imageUrl,
    required this.gender,
    required this.target,
  });

  @override
  State<EditTargetForm> createState() => _EditTargetFormState();
}

class _EditTargetFormState extends State<EditTargetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<Surat> suratList = [];
  List<Pengajar> pengajarList = [];
  Surat? selectedSurat;
  Pengajar? selectedPengajar;
  DateTime? _selectedTglMulai;
  DateTime? _selectedTglTarget;

  TextEditingController ayatAwalController = TextEditingController();
  TextEditingController ayatAkhirController = TextEditingController();
  TextEditingController tanggalMulaiController = TextEditingController();
  TextEditingController tanggalTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Prefill data controller dari target yang dikirim
    ayatAwalController.text = widget.target.ayatAwal.toString();
    ayatAkhirController.text = widget.target.ayatAkhir.toString();
    tanggalMulaiController.text = formatTanggal(widget.target.tglMulai);
    tanggalTargetController.text = formatTanggal(widget.target.tglTarget);

    _selectedTglMulai = widget.target.tglMulai;
    _selectedTglTarget = widget.target.tglTarget;

    _loadSuratList();
    _loadPengajarList();
  }

  Future<void> _loadSuratList() async {
    try {
      final data = await SuratService.fetchSuratList();
      setState(() {
        suratList = data;

        selectedSurat = data.firstWhere(
          (s) => s.id == widget.target.idSurat,
          orElse: () => data.first,
        );
      });
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        SnackbarHelper.showError(context, "Gagal memuat surat");
      }
    }
  }

  Future<void> _loadPengajarList() async {
    try {
      final data = await ApiService.fetchPengajar();
      setState(() {
        pengajarList = data;

        selectedPengajar = data.firstWhere(
          (p) => p.id == widget.target.idPengajar,
          orElse: () => data.first,
        );
      });
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        SnackbarHelper.showError(context, "Gagal memuat pengajar");
      }
    }
  }

  @override
  void dispose() {
    ayatAwalController.dispose();
    ayatAkhirController.dispose();
    tanggalMulaiController.dispose();
    tanggalTargetController.dispose();

    super.dispose();
  }

  bool _isFormValid() {
    return selectedSurat != null &&
        selectedPengajar != null &&
        _selectedTglMulai != null &&
        _selectedTglTarget != null &&
        ayatAwalController.text.trim().isNotEmpty &&
        ayatAkhirController.text.trim().isNotEmpty &&
        tanggalMulaiController.text.trim().isNotEmpty &&
        tanggalTargetController.text.trim().isNotEmpty;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      SnackbarHelper.showError(
          context, "Harap lengkapi semua field dengan benar");
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final ayatAwal = int.tryParse(ayatAwalController.text.trim());
    final ayatAkhir = int.tryParse(ayatAkhirController.text.trim());
    final tanggalMulai = DateFormat('yyyy-MM-dd').format(_selectedTglMulai!);
    final tanggalTarget = DateFormat('yyyy-MM-dd').format(_selectedTglTarget!);

    try {
      if (widget.santri.idKelas == null) {
        throw Exception(
            "Santri belum memiliki kelas. Tidak bisa menambahkan target.");
      }

      final payload = {
        'id_santri': widget.santri.id,
        'id_kelas': widget.santri.idKelas,
        'id_surat': selectedSurat?.id ?? 0,
        'id_pengajar': selectedPengajar?.id ?? 0,
        'jumlah_ayat_target_awal': ayatAwal,
        'jumlah_ayat_target': ayatAkhir,
        'tgl_mulai': tanggalMulai,
        'tgl_target': tanggalTarget,
      };

      print("Payload yang akan dikirim: $payload");

      // Debug print untuk memastikan data yang dikirim
      print("=== Data Target Hafalan ===");
      print("Nama Santri: ${widget.santri.nama}");
      print("Surat: ${selectedSurat?.nama ?? 'Tidak ada surat'}");
      print(
          "Ustadz/Ustadzah: ${selectedPengajar?.nama ?? 'Tidak ada pengajar'}");
      print("Ayat: $ayatAwal - $ayatAkhir");
      print("Tanggal Mulai: $tanggalMulai");
      print("Tanggal Target: $tanggalTarget");

      final response =
          await TargetService.updateTarget(widget.target.idTarget, payload);

      if (response['data'] == null) {
        throw Exception("Data tidak ditemukan dalam response API.");
      }

      Future.microtask(() {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context, true);
          SnackbarHelper.showSuccess(
              context, "Target Hafalan berhasil ditambahkan");
        }
      });
    } catch (e) {
      String errorMess = "Gagal Menyimpan Target";

      if (e is ApiException) {
        errorMess = e.message;
      }
      if (mounted) {
        SnackbarHelper.showError(context, errorMess);
      }
      print("Error submitting form: $e");
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
                  child: SingleChildScrollView(
                    // Added ScrollView to prevent overflow
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
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        buildLabel("Surat"),
                        DropdownButtonFormField<Surat>(
                          value: selectedSurat,
                          decoration: InputDecoration(
                            hintText: "Pilih Surat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                          ),
                          items: suratList.map((surat) {
                            return DropdownMenuItem<Surat>(
                              value: surat,
                              child: Text(surat.nama),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSurat = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Silakan pilih surat';
                            }
                            return null;
                          },
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

                        // Tanggal Mulai dan Tanggal Selesai
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildLabel("Tanggal Mulai"),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _selectedTglMulai = picked;
                                            tanggalMulaiController.text =
                                                DateFormat(
                                                        'd MMMM yyyy', 'id_ID')
                                                    .format(picked);
                                          });
                                        }
                                      },
                                      child: AbsorbPointer(
                                          child: buildTextField(
                                              "Masukkan Tanggal",
                                              controller:
                                                  tanggalMulaiController)),
                                    )
                                  ]),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildLabel("Tanggal Target"),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _selectedTglTarget = picked;
                                            tanggalTargetController.text =
                                                DateFormat(
                                                        'd MMMM yyyy', 'id_ID')
                                                    .format(picked);
                                          });
                                        }
                                      },
                                      child: AbsorbPointer(
                                          child: buildTextField(
                                              "Masukkan Tanggal",
                                              controller:
                                                  tanggalTargetController)),
                                    )
                                  ]),
                            ),
                          ],
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
