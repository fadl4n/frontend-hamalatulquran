import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/custom_table.dart';
import 'package:frontend_hamalatulquran/widgets/header_section.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AbsensiDetail extends StatefulWidget {
  final int id;
  final String namaKelas;
  const AbsensiDetail({super.key, required this.id, required this.namaKelas});

  @override
  State<AbsensiDetail> createState() => _AbsensiDetailState();
}

class _AbsensiDetailState extends State<AbsensiDetail> {
  List<Santri> santriList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getSantribyKelas();
  }

  void _getSantribyKelas() async {
    try {
      List<Santri> data = await ApiService().fetchSantriByKelas(widget.id);
      setState(() {
        santriList = data;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      print("❌ Error: $e");
      print("📌 Stacktrace: $stacktrace");
      setState(() {
        isLoading = false;
        errorMessage = "Gagal mengambil data. Silakan coba lagi nanti.";
      });
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      appBar: CustomAppbar(
          title: "Absesni Kelas ${widget.namaKelas}", fontSize: 16.sp),
      body: Column(
        children: [
          _headerSection(),
          Expanded(child: _absensiSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // nanti buka form absensi di sini
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, size: 28.w),
      ),
    );
  }

  Widget _headerSection() {
    return HeaderSection(
      title: widget.namaKelas,
      jumlahSantri: santriList.length,
    );
  }

  Widget _absensiSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: isLoading
            ? _shimmerAbsensiPlaceholder()
            : santriList.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data santri di kelas ini.",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.black),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Rekap Absensi",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: CustomTable(
                            headers: ["NISN", "Nama", getFormattedDate()],
                            rows: santriList
                                .map((e) => [e.nisn, e.nama, "-"])
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _shimmerAbsensiPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 20.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 40.h,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
