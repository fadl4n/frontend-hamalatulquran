import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/models/target_hafalan_model.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/history_target_hafalan.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/hafalan/target_service.dart';
import '../../services/utils/snackbar_helper.dart';
import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/forms/edit_target_form.dart';
import '../../widgets/forms/input_target_form.dart';
import '../../widgets/layout/content_section.dart';
import '../../widgets/layout/header_section.dart';
import '../../widgets/target_hafalan/target_hafalan_item.dart';

class ManajemenHafalanPage extends StatefulWidget {
  final Santri santri;

  const ManajemenHafalanPage({super.key, required this.santri});

  @override
  State<ManajemenHafalanPage> createState() => _ManajemenHafalanPageState();
}

class _ManajemenHafalanPageState extends State<ManajemenHafalanPage> {
  List<TargetHafalan> targetHafalan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTargetHafalan();
  }

  Future<void> fetchTargetHafalan() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await TargetService.fetchAllTargetBySantri(
        widget.santri.id.toString(),
      );

      setState(() {
        targetHafalan = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackbarHelper.showError(context, 'Error: $e');
      print("Error: $e");
    }
  }

  Future<void> _showInputTargetForm({
    required String imageUrl,
    required String gender,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => InputTargetForm(
        santri: widget.santri,
        imageUrl: imageUrl,
        gender: gender,
      ),
    );
    // Refresh data kalau hasilnya bukan null
    if (result == true) {
      await fetchTargetHafalan();
    }
  }

  Future<void> _showEditTargetForm({
    required String imageUrl,
    required String gender,
    required TargetHafalan target,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditTargetForm(
          santri: widget.santri,
          imageUrl: imageUrl,
          gender: gender,
          target: target),
    );
    // Refresh data kalau hasilnya bukan null
    if (result == true) {
      await fetchTargetHafalan();
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
                HeaderSection(
                  title: widget.santri.nama,
                  nisn: widget.santri.nisn,
                  kelasSantri: widget.santri.kelasNama,
                ),
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _listHafalanSection() {
    return ContentSection(
      title: "Target Hafalan",
      itemCount: targetHafalan.isEmpty ? 1 : targetHafalan.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: TargetHafalanItem(
            hafalan: hafalan,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryTargetHafalan(
                    idTarget: hafalan.idTarget,
                    idSurat: hafalan.idSurat,
                    namaSurat: hafalan.namaSurat,
                    jumlahAyat: hafalan.jumlahAyat,
                    targetAyat: '${hafalan.ayatAwal} - ${hafalan.ayatAkhir}',
                    ayatTargetAkhir: hafalan.ayatAkhir,
                    santri: widget.santri,
                    hideFAB: true,
                  ),
                ),
              );
            },
            onEdit: (context) async {
              await _showEditTargetForm(
                imageUrl: widget.santri.fotoSantri ?? '',
                gender: widget.santri.jenisKelamin,
                target: targetHafalan[index],
              );
            },
            onDelete: (_) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Yakin ingin menghapus target ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                if (context.mounted) {
                  SnackbarHelper.showSuccess(
                      context, 'Target berhasil dihapus!');
                }
                try {
                  await TargetService.deleteTargetById(
                      hafalan.idTarget); // pastiin method ini ada
                  await fetchTargetHafalan();
                } catch (e) {
                  debugPrint('Error saat hapus: $e');
                  if (context.mounted) {
                    SnackbarHelper.showError(context, "$e");
                  }
                }
              }
            },
          ),
        );
      },
    );
  }
}
