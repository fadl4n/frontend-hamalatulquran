import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/layanan_page.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/target_hafalan_page.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/data_kelas_page.dart';

class MenuGrid extends StatelessWidget {
  final bool isPengajar;

  const MenuGrid({super.key, required this.isPengajar});

  @override
  Widget build(BuildContext context) {
    print("isPengajar di MenuGrid: $isPengajar"); // Debugging

    final menuItems = isPengajar ? pengajarMenuItems : waliSantriMenuItems;

    print(
        "🔍 Menu yang dipilih berdasarkan isPengajar ($isPengajar): ${menuItems.map((item) => item['label']).toList()}");

    int fullRowCount = (menuItems.length ~/ 4) * 4;
    List<Map<String, dynamic>> fullGridItems =
        menuItems.sublist(0, fullRowCount);
    List<Map<String, dynamic>> remainingItems = menuItems.sublist(fullRowCount);

    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15.h,
            mainAxisExtent: 100,
            childAspectRatio: 1.2,
          ),
          itemCount: fullGridItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (fullGridItems[index]["label"] == "Lainnya...") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LayananPage()),
                  );
                } else if (fullGridItems[index]["label"] == "Target Hafalan") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TargetHafalanPage()),
                  );
                } else if (fullGridItems[index]["label"] == "Data Santri") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataKelasPage()),
                  );
                }
              },
              child: _buildMenuItem(
                fullGridItems[index]["color"],
                fullGridItems[index]["icon"],
                fullGridItems[index]["label"],
              ),
            );
          },
        ),
        if (remainingItems.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Wrap(
              spacing: 15.w,
              runSpacing: 10.h,
              alignment: WrapAlignment.center,
              children: remainingItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    if (item["label"] == "Lainnya...") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LayananPage()),
                      );
                    }
                  },
                  child: _buildMenuItem(
                      item["color"], item["icon"], item["label"]),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  static final List<Map<String, dynamic>> pengajarMenuItems = [
    {
      "color": Colors.lightGreen.shade600,
      "icon": Icons.flag_outlined,
      "label": "Target Hafalan"
    },
    {
      "color": Colors.blue.shade800,
      "icon": Icons.menu_book_outlined,
      "label": "Rekap Absensi"
    },
    {
      "color": Colors.yellow.shade600,
      "icon": Icons.list_alt_rounded,
      "label": "Management Hafalan"
    },
    {
      "color": Colors.purple.shade600,
      "icon": Icons.checklist_outlined,
      "label": "Evaluasi Muroja'ah"
    },
    {"color": Colors.lightGreen, "icon": Icons.people, "label": "Data Santri"},
    {
      "color": Colors.cyan.shade800,
      "icon": Icons.person_rounded,
      "label": "Data Pengajar"
    },
    {
      "color": Colors.blue.shade800,
      "icon": Icons.note_rounded,
      "label": "Laporan"
    },
    {
      "color": Colors.green.shade800,
      "icon": Icons.more_horiz,
      "label": "Lainnya..."
    },
  ];

  static final List<Map<String, dynamic>> waliSantriMenuItems = [
    {
      "color": Colors.orange,
      "icon": Icons.flag_outlined,
      "label": "Target Hafalan"
    },
    {
      "color": Colors.red.shade700,
      "icon": Icons.account_balance_wallet_rounded,
      "label": "Data Infaq"
    },
    {
      "color": Colors.deepOrange.shade700,
      "icon": Icons.other_houses_rounded,
      "label": "Lembaga"
    },
    {
      "color": Colors.deepPurple,
      "icon": Icons.checklist_rounded,
      "label": "Evaluasi Muroja'ah"
    },
    {"color": Colors.lightGreen, "icon": Icons.people, "label": "Data Santri"},
    {
      "color": const Color.fromARGB(255, 4, 143, 185),
      "icon": Icons.person_2_rounded,
      "label": "Data Pengajar"
    },
    {
      "color": Colors.teal,
      "icon": Icons.fact_check_outlined,
      "label": "Rekap Absensi"
    },
  ];

  Widget _buildMenuItem(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 25.sp),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 75.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
