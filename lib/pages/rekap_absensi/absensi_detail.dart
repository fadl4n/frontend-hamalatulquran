import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.r),
            ),
          ),
        ),
        title: Text(
          "Detail Absensi Kelas ${widget.namaKelas}",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Center(
            child: Text(
              widget.namaKelas,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Center(
            child: Text(
              "Jumlah Santri: ${santriList.length} Santri", // bisa dinamis nanti
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
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
                          child: Table(
                            border: TableBorder.all(color: Colors.green),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(2),
                            },
                            children: [
                              _tableHeaderRow(),
                              ...santriList.asMap().entries.map((entry) {
                                return _santriTableRow(entry.value, entry.key);
                              }).toList(),
                            ],
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

  TableRow _tableHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.green.shade100),
      children: [
        _tableCell("NISN", true),
        _tableCell("Nama", true),
        _tableCell(getFormattedDate(), true),
      ],
    );
  }

  TableRow _santriTableRow(Santri santri, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.green.shade50 : Colors.green.shade100,
      ),
      children: [
        _tableCell(santri.nisn, false),
        _tableCell(santri.nama, false),
        _tableCell("-", false), // nanti bisa ganti ke status hadir
      ],
    );
  }

  Widget _tableCell(String text, bool isHeader) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
