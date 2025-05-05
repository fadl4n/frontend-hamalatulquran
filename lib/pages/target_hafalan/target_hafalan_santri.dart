import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/target_by_group_model.dart';
import 'package:frontend_hamalatulquran/services/target_service.dart';
import 'package:frontend_hamalatulquran/widgets/content_section.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/header_section.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/history_target_hafalan.dart';
import 'package:frontend_hamalatulquran/widgets/input_target_form.dart';
import 'package:google_fonts/google_fonts.dart';

class TargetHafalanSantri extends StatefulWidget {
  final Santri santri;

  const TargetHafalanSantri({super.key, required this.santri});

  @override
  State<TargetHafalanSantri> createState() => _TargetHafalanSantriState();
}

class _TargetHafalanSantriState extends State<TargetHafalanSantri> {
  List<TargetByGroup> targetHafalan = [];
  bool isLoading = true;
  Future<void> _showInputTargetForm({
    required String imageUrl,
    required String gender,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return InputTargetForm(
          santri: widget.santri,
          imageUrl: imageUrl,
          gender: gender,
        );
      },
    ).then((_){
      fetchTargetHafalan();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTargetHafalan();
  }

  Future<void> fetchTargetHafalan() async {
    try {
      // Gunakan widget.idGroup jika sudah tersedia
      final idGroup = widget.santri.idGroup;
      if (idGroup == null) {
        throw Exception('ID Group tidak ditemukan');
      }
      final result = await TargetService.fetchTargetBySantriGroup(
        widget.santri.id.toString(),
        idGroup.toString(),
      );

      setState(() {
        targetHafalan = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
          title: "Target Hafalan ${widget.santri.nama}", fontSize: 15.sp),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _headerSection(),
                Expanded(child: _listHafalanSection()),
              ],
            ),
    );
  }

  Widget _headerSection() {
    return HeaderSection(
      title: widget.santri.nama,
      nisn: widget.santri.nisn,
      kelasSantri: widget.santri.kelasNama,
    );
  }

  Widget _listHafalanSection() {
    return ContentSection(
      title: "Target Hafalan",
      itemCount: targetHafalan.isEmpty
          ? 1
          : targetHafalan.length, // Kalau kosong, set itemCount jadi 1
      itemBuilder: (context, index) {
        // Jika targetHafalan kosong, tampilkan pesan
        if (targetHafalan.isEmpty) {
          // Panggil fetchTargetHafalan sebelum return untuk memastikan data diambil
          fetchTargetHafalan(); // Ambil data terlebih dahulu, jika perlu.
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum ada target hafalan 🥲",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Menampilkan form input target
                    await _showInputTargetForm(
                      imageUrl: widget.santri.fotoSantri ?? '',
                      gender: widget.santri.jenisKelamin,
                    );
                    // Setelah dialog ditutup, lakukan refresh data
                    fetchTargetHafalan();
                  },
                  child: const Text("Tambah target baru"),
                ),
              ],
            ),
          );
        }

        // Jika tidak kosong, tampilkan item
        final hafalan = targetHafalan[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryTargetHafalan(
                    namaSurat: hafalan.namaSurat,
                    jumlahAyat: hafalan.jumlahAyat,
                    santri: widget.santri),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Kiri: Nama surat dan jumlah ayat
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hafalan.namaSurat,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Jumlah Ayat: ${hafalan.jumlahAyat}",
                        style: GoogleFonts.poppins(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  // Kanan: Icon panah
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                    size: 18.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
