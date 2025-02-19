import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuGrid extends StatefulWidget {
  final bool isPengajar;

  const MenuGrid({super.key, required this.isPengajar});

  @override
  _MenuGridState createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  @override
  Widget build(BuildContext context) {
    final menuItems =
        widget.isPengajar ? pengajarMenuItems : waliSantriMenuItems;

    // Hitung item yang bisa masuk GridView dengan kelipatan 4
    int fullRowCount = (menuItems.length ~/ 4) * 4;
    List<Map<String, dynamic>> fullGridItems =
        menuItems.sublist(0, fullRowCount);
    List<Map<String, dynamic>> remainingItems = menuItems.sublist(fullRowCount);

    return Column(
      children: [
        GridView.builder(
          padding:
              EdgeInsets.symmetric(horizontal: 25.w), // Atur padding global
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15.h, // Jarak vertikal antar item
            crossAxisSpacing: 8.w, // Jarak horizontal antar item
            mainAxisExtent: 110, // Atur tinggi setiap item
            childAspectRatio: 1.5,
          ),
          itemCount: fullGridItems.length,
          itemBuilder: (context, index) {
            return _buildMenuItem(
              fullGridItems[index]["color"],
              fullGridItems[index]["icon"],
              fullGridItems[index]["label"],
            );
          },
        ),
        if (remainingItems.isNotEmpty)
          Padding(
            padding:
                EdgeInsets.only(top: 8.h), // Atur jarak dari GridView ke Wrap
            child: Wrap(
              spacing: 15.w, // Atur jarak horizontal antar item
              runSpacing: 10.h, // Atur jarak vertikal antar baris item
              alignment: WrapAlignment.center,
              children: remainingItems
                  .map((item) => _buildMenuItem(
                        item["color"],
                        item["icon"],
                        item["label"],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  static final List<Map<String, dynamic>> pengajarMenuItems = [
    {
      "color": Colors.orange,
      "icon": Icons.flag_outlined,
      "label": "Target Hafalan"
    },
    {
      "color": Colors.deepOrange,
      "icon": Icons.menu_book_outlined,
      "label": "Hafalan Hari Ini"
    },
    {
      "color": Colors.purple,
      "icon": Icons.list_alt_rounded,
      "label": "Management Hafalan"
    },
    {
      "color": Colors.amber,
      "icon": Icons.checklist_outlined,
      "label": "Evaluasi Muroja'ah"
    },
    {"color": Colors.blue, "icon": Icons.people, "label": "Data Santri"},
    {
      "color": Colors.indigo,
      "icon": Icons.person_rounded,
      "label": "Data Pengajar"
    },
    {
      "color": Colors.teal,
      "icon": Icons.fact_check_outlined,
      "label": "Rekap Absensi"
    },
    {"color": Colors.grey, "icon": Icons.more_horiz, "label": "Lainnya..."},
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
          width: 60.w, // Atur lebar supaya teks bisa wrap
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2, // Batasi maksimal dua baris
            overflow: TextOverflow.visible, // Biar nggak kepotong
            softWrap: true, // Pastikan teks bisa wrap ke baris berikutnya
          ),
        ),
      ],
    );
  }
}
