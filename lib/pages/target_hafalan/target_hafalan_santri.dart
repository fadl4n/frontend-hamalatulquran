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
  final int? idGroup;
  final Function(int?) onIdGroupUpdated;

  const TargetHafalanSantri({
    super.key,
    required this.santri,
    required this.idGroup,
    required this.onIdGroupUpdated,
  });

  @override
  State<TargetHafalanSantri> createState() => _TargetHafalanSantriState();
}

class _TargetHafalanSantriState extends State<TargetHafalanSantri> {
  List<TargetByGroup> targetHafalan = [];
  bool isLoading = true;
  late int? currentIdGroup;

  @override
  void initState() {
    super.initState();
    currentIdGroup = widget.idGroup;
    fetchTargetHafalan();
  }

  Future<void> fetchTargetHafalan() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Pastikan currentIdGroup yang terbaru digunakan untuk fetch
      print("Fetching target for group: $currentIdGroup");
      final result = await TargetService.fetchTargetBySantriGroup(
          widget.santri.id.toString(), currentIdGroup?.toString() ?? '0');

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

  Future<void> _showInputTargetForm({
    required String imageUrl,
    required String gender,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => InputTargetForm(
        santri: widget.santri,
      imageUrl: imageUrl,
        gender: gender,
      ),
    );

    if (result != null) {
      final parseId = int.tryParse(result);
      if (parseId != null) {
        print('Group ID baru: $parseId');
        setState(() {
          currentIdGroup = parseId; // update ke group baru
        });
        widget.onIdGroupUpdated(parseId);
        await fetchTargetHafalan(); // fetch ulang pakai group ID baru
      } else {
        print("Parsing ID gagal: result bukan angka");
      }
    } else {
      print("Dialog dibatalakn / result null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
        title: "Target Hafalan ${widget.santri.nama}",
        fontSize: 15.sp,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _headerSection(),
                Expanded(child: _listHafalanSection()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () async {
          await _showInputTargetForm(
            imageUrl: widget.santri.fotoSantri ?? '',
            gender: widget.santri.jenisKelamin,
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
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
      itemCount: targetHafalan.isEmpty ? 1 : targetHafalan.length,
      itemBuilder: (context, index) {
        if (targetHafalan.isEmpty) {
          return Center(
            child: Text(
              "Belum ada target hafalan 🥲",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          );
        }

        final hafalan = targetHafalan[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryTargetHafalan(
                  namaSurat: hafalan.namaSurat,
                  jumlahAyat: hafalan.jumlahAyat,
                  santri: widget.santri,
                ),
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
