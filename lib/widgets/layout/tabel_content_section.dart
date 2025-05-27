import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/widgets/shimmer/shimmer_tabel_placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../table/custom_table.dart';

class TabelContentSection extends StatelessWidget {
  final List<List<String>> rows;
  final List<String> headers;
  final bool isLoading;
  final String title;

  const TabelContentSection({
    Key? key,
    required this.rows,
    required this.headers,
    this.isLoading = false,
    this.title = "Tabel Data",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ? const ShimmerTabelPlaceholder()
            : rows.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data untuk ditampilkan.",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          title,
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
                            headers: headers,
                            rows: rows,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
