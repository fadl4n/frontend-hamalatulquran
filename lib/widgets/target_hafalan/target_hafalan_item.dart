import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend_hamalatulquran/models/hafalan_base.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../services/utils/formatter.dart';

class TargetHafalanItem extends StatelessWidget {
  final HafalanBase hafalan;
  final VoidCallback? onTap;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;

  const TargetHafalanItem({
    super.key,
    required this.hafalan,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    double persentaseValue = double.tryParse(hafalan.persentase) ?? 0.0;
    Color percentColor = persentaseValue >= 85
        ? Colors.green
        : persentaseValue >= 70
            ? Colors.orange
            : Colors.red;

    Widget content = GestureDetector(
      onTap: onTap,
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
                  "Jumlah target ayat: ${hafalan.jumlahAyat}",
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Target Selesai: ${formatTanggal(hafalan.tglTarget)}",
                  style: GoogleFonts.poppins(fontSize: 12.sp),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 10.0,
                    percent: persentaseValue / 100,
                    center: Text("${hafalan.persentase}%",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    progressColor: percentColor,
                    backgroundColor: Colors.grey.shade300,
                    animation: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 18.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (onEdit != null || onDelete != null) {
      return Slidable(
        child: content,
        key: ValueKey(hafalan.idTarget),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            if (onEdit != null)
              SlidableAction(
                onPressed: onEdit,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit_rounded,
                label: 'Edit',
              ),
            if (onDelete != null)
              SlidableAction(
                onPressed: onDelete,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline_rounded,
                label: 'Hapus',
              ),
          ],
        ),
      );
    }
    return content;
  }
}
