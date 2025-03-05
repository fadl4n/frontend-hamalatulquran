import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayananPage extends StatelessWidget {
  final List<Map<String, dynamic>> layananItems = [
    {
      "color": Colors.lightGreen,
      "icon": Icons.flag_outlined,
      "label": "Target Hafalan"
    },
    {
      "color": Colors.pink,
      "icon": Icons.account_balance_wallet_rounded,
      "label": "Data Infaq"
    },
    {
      "color": Colors.amber,
      "icon": Icons.list_alt_rounded,
      "label": "Management Hafalan"
    },
    {
      "color": Colors.deepPurple,
      "icon": Icons.checklist_rounded,
      "label": "Evaluasi Muroja'ah"
    },
    {"color": Colors.teal, "icon": Icons.people, "label": "Data Santri"},
    {"color": Colors.blueGrey, "icon": Icons.person, "label": "Data Pengajar"},
    {
      "color": Colors.blue,
      "icon": Icons.fact_check_outlined,
      "label": "Rekap Absensi"
    },
    {
      "color": Colors.red,
      "icon": Icons.other_houses_rounded,
      "label": "Lembaga"
    },
    {
      "color": Colors.blueAccent,
      "icon": Icons.description_rounded,
      "label": "Laporan"
    },
  ];

  LayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Layanan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15.w, // Jarak horizontal antar item
              mainAxisSpacing: 15.h, // Jarak vertikal antar item
              mainAxisExtent: 110,
              childAspectRatio: 1.2, // Rasio item (bisa disesuaikan)
            ),
            itemCount: layananItems.length,
            itemBuilder: (context, index) {
              final item = layananItems[index];
              return _buildMenuItem(
                item["color"],
                item["icon"],
                item["label"],
              );
            }),
      ),
    );
  }

  Widget _buildMenuItem(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 25.sp),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 75.w, // Supaya teks bisa wrapping
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
