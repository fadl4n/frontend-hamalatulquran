import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/surat_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:frontend_hamalatulquran/services/surat_service.dart';
import 'package:frontend_hamalatulquran/services/target_service.dart';
import 'package:frontend_hamalatulquran/widgets/profile_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTargetForm extends StatefulWidget {
  final Santri santri;
  final String imageUrl;
  final String gender;
  const InputTargetForm({
    super.key,
    required this.santri,
    required this.imageUrl,
    required this.gender,
  });

  @override
  State<InputTargetForm> createState() => _InputTargetFormState();
}

class _InputTargetFormState extends State<InputTargetForm> {
  TextEditingController ayatAwalController = TextEditingController();
  TextEditingController ayatAkhirController = TextEditingController();
  TextEditingController tanggalMulaiController = TextEditingController();
  TextEditingController tanggalTargetController = TextEditingController();
  TextEditingController targetGroupController = TextEditingController();

  List<Surat> suratList = [];
  List<Pengajar> pengajarList = [];
  Surat? selectedSurat;
  Pengajar? selectedPengajar;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuratList();
    _loadPengajarList();
  }

  Future<void> _loadSuratList() async {
    try {
      final data = await SuratService.fetchSuratList();
      setState(() {
        suratList = data;
      });
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat surat")),
        );
      }
    }
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat pengajar")),
        );
      }
    }
  }

  @override
  void dispose() {
    ayatAwalController.dispose();
    ayatAkhirController.dispose();
    tanggalMulaiController.dispose();
    tanggalTargetController.dispose();
    targetGroupController.dispose();
    super.dispose();
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

    final ayatAwalText = ayatAwalController.text.trim();
    final ayatAkhirText = ayatAkhirController.text.trim();
    final tanggalMulai = tanggalMulaiController.text.trim();
    final tanggalTarget = tanggalTargetController.text.trim();
    final targetGroupText = targetGroupController.text.trim();
    final ayatAwal = int.tryParse(ayatAwalText);
    final ayatAkhir = int.tryParse(ayatAkhirText);
    final targetGroup = int.tryParse(targetGroupText);

    // Debug print untuk memeriksa nilai yang diambil
    print("Selected Surat: $selectedSurat");
    print("Id Kelas Santri: ${widget.santri.idKelas}");
    print("Selected Pengajar: $selectedPengajar");
    print("Ayat Awal: $ayatAwal");
    print("Ayat Akhir: $ayatAkhir");
    print("Tanggal Mulai: $tanggalMulai");
    print("Tanggal Target: $tanggalTarget");
    print("Target Group: $targetGroup");

    if (selectedSurat == null ||
        selectedPengajar == null ||
        ayatAwal == null ||
        tanggalMulai.isEmpty ||
        tanggalTarget.isEmpty ||
        ayatAkhir == null ||
        targetGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Harap lengkapi semua field dengan benar")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Periksa id_kelas terlebih dahulu
      if (widget.santri.idKelas == null) {
        throw Exception(
            "ID Kelas tidak tersedia. Santri ini mungkin belum memiliki kelas.");
      }

      // Debug print untuk memastikan payload yang dikirim
      final payload = {
        'id_santri': widget.santri.id,
        'id_kelas': widget.santri.idKelas, // id_kelas yang dibutuhkan oleh API
        'id_surat': selectedSurat?.id ?? 0,
        'jumlah_ayat_target_awal': ayatAwal,
        'jumlah_ayat_target': ayatAkhir,
        'tgl_mulai': tanggalMulai,
        'tgl_target': tanggalTarget,
        'id_group': targetGroup,
      };

      print("Payload yang akan dikirim: $payload");

      // Panggil createTarget tanpa mencoba mengakses return value-nya
      await TargetService.createTarget(payload);

      // Debug print untuk memastikan data yang dikirim
      print("=== Data Target Hafalan ===");
      print("Nama Santri: ${widget.santri.nama}");
      print("Surat: ${selectedSurat?.nama ?? 'Tidak ada surat'}");
      print(
          "Ustadz/Ustadzah: ${selectedPengajar?.nama ?? 'Tidak ada pengajar'}");
      print("Ayat: $ayatAwal - $ayatAkhir");
      print("Tanggal Mulai: $tanggalMulai");
      print("Tanggal Target: $tanggalTarget");
      print("Group Target: $targetGroup");

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Target Hafalan berhasil ditambahkan")),
        );
      }
    } catch (e) {
      print("Error submitting form: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget buildTextField(String hint,
      {required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Field ini tidak boleh kosong';
            }
            return null;
          },
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
                                        final selectedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100));
                                        if (selectedDate != null) {
                                          setState(() {
                                            tanggalMulaiController.text =
                                                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
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
                                        final selectedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100));
                                        if (selectedDate != null) {
                                          setState(() {
                                            tanggalTargetController.text =
                                                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
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
                        SizedBox(height: 20.h),
                        buildLabel("Group Target"),
                        buildTextField("Contoh: 1",
                            controller: targetGroupController,
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
                                    : () => Navigator.pop(context),
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
                        )
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
