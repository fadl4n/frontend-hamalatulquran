import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/evaluasi_murojaah/evaluasi_list_santri.dart';
import 'package:frontend_hamalatulquran/pages/laporan/laporan_page_kelas.dart';
import 'package:frontend_hamalatulquran/pages/layanan_page.dart';
import 'package:frontend_hamalatulquran/pages/rekap_absensi/rekap_absensi.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/target_hafalan_page.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/data_kelas_page.dart';
import 'package:frontend_hamalatulquran/pages/data_pengajar/data_pengajar_page.dart';

class MenuGrid extends StatelessWidget {
  final bool isPengajar;

  const MenuGrid({super.key, required this.isPengajar});

  @override
  Widget build(BuildContext context) {
    final menuItems = isPengajar ? _pengajarMenuItems : _waliSantriMenuItems;

    final int fullRowCount = (menuItems.length ~/ 4) * 4;
    final List<MenuItem> fullGridItems = menuItems.sublist(0, fullRowCount);
    final List<MenuItem> remainingItems = menuItems.sublist(fullRowCount);

    return Column(
      children: [
        _buildGrid(fullGridItems, context),
        if (remainingItems.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Wrap(
              spacing: 15.w,
              runSpacing: 10.h,
              alignment: WrapAlignment.center,
              children: remainingItems
                  .map((item) => _buildMenuButton(item, context))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid(List<MenuItem> items, BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15.h,
        mainAxisExtent: 100,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMenuButton(items[index], context),
    );
  }

  Widget _buildMenuButton(MenuItem item, BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, item.label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: item.color,
            child: Icon(item.icon, color: Colors.white, size: 25.sp),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 75.w,
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, String label) {
    final routes = <String, WidgetBuilder>{
      "Lainnya...": (context) => LayananPage(),
      "Target Hafalan": (context) => const TargetHafalanPage(),
      "Data Santri": (context) => const DataKelasPage(),
      "Data Pengajar": (context) => const DataPengajarPage(),
      "Rekap Absensi": (context) => const RekapAbsensi(),
      "Laporan": (context) => const LaporanPageKelas(),
      "Evaluasi Muroja'ah": (context) => const EvaluasiListSantri(),
    };

    if (routes.containsKey(label)) {
      Navigator.push(context, MaterialPageRoute(builder: routes[label]!));
    } else {
      debugPrint("⚠️ No route found for: $label");
    }
  }

  // ⬇️ Data model biar ga pake Map terus
  static final List<MenuItem> _pengajarMenuItems = [
    MenuItem("Target Hafalan", Colors.lightGreen.shade600, Icons.flag_outlined),
    MenuItem("Rekap Absensi", Colors.blue.shade800, Icons.menu_book_outlined),
    MenuItem(
        "Management Hafalan", Colors.yellow.shade600, Icons.list_alt_rounded),
    MenuItem(
        "Evaluasi Muroja'ah", Colors.purple.shade600, Icons.checklist_outlined),
    MenuItem("Data Santri", Colors.lightGreen, Icons.people),
    MenuItem("Data Pengajar", Colors.cyan.shade800, Icons.person_rounded),
    MenuItem("Laporan", Colors.blue.shade800, Icons.note_rounded),
    MenuItem("Lainnya...", Colors.green.shade800, Icons.more_horiz),
  ];

  static final List<MenuItem> _waliSantriMenuItems = [
    MenuItem("Target Hafalan", Colors.orange, Icons.flag_outlined),
    MenuItem("Data Infaq", Colors.red.shade700,
        Icons.account_balance_wallet_rounded),
    MenuItem("Lembaga", Colors.deepOrange.shade700, Icons.other_houses_rounded),
    MenuItem("Evaluasi Muroja'ah", Colors.deepPurple, Icons.checklist_rounded),
    MenuItem("Data Santri", Colors.lightGreen, Icons.people),
    MenuItem("Data Pengajar", const Color.fromARGB(255, 4, 143, 185),
        Icons.person_2_rounded),
    MenuItem("Rekap Absensi", Colors.teal, Icons.fact_check_outlined),
  ];
}

// 📦 Model class biar gak rawan typo
class MenuItem {
  final String label;
  final Color color;
  final IconData icon;

  MenuItem(this.label, this.color, this.icon);
}
