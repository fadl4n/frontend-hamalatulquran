import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/data_pengajar/data_pengajar_page.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/data_kelas_page.dart';
import 'package:frontend_hamalatulquran/pages/evaluasi_murojaah/evaluasi_list_santri.dart';
import 'package:frontend_hamalatulquran/pages/laporan/laporan_page_kelas.dart';
import 'package:frontend_hamalatulquran/pages/manajemen_hafalan/list_kelas_page.dart';
import 'package:frontend_hamalatulquran/pages/rekap_absensi/rekap_absensi.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/target_hafalan_page.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';

class LainnyaPage extends StatelessWidget {
  final List<Map<String, dynamic>> layananItems = [
    {
      "color": Colors.lightGreen,
      "icon": Icons.flag_outlined,
      "label": "Target Hafalan"
    },
    {
      "color": Colors.teal,
      "icon": Icons.people,
      "label": "Data Santri",
    },
    {
      "color": Colors.blueGrey,
      "icon": Icons.person,
      "label": "Data Pengajar",
    },
    {
      "color": Colors.deepPurple,
      "icon": Icons.checklist_rounded,
      "label": "Evaluasi Muroja'ah"
    },
    {
      "color": Colors.pink,
      "icon": Icons.account_balance_wallet_rounded,
      "label": "Data Infaq"
    },
    {
      "color": Colors.blue,
      "icon": Icons.fact_check_outlined,
      "label": "Rekap Absensi"
    },
    {
      "color": Colors.amber,
      "icon": Icons.list_alt_rounded,
      "label": "Management Hafalan"
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

  LainnyaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Layanan", fontSize: 18.sp),
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
              return _buildMenuItem(context,
                item["color"],
                item["icon"],
                item["label"],
              );
            }),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String label) {
    debugPrint("🚀 Navigating to $label");

    final routes = <String, WidgetBuilder>{
      "Lainnya...": (context) => LainnyaPage(),
      "Target Hafalan": (context) => const TargetHafalanPage(),
      "Data Santri": (context) => const DataKelasPage(),
      "Data Pengajar": (context) => const DataPengajarPage(),
      "Management Hafalan": (context) =>  const ListKelasPage(),
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

  Widget _buildMenuItem(BuildContext context, Color color, IconData icon, String label) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, label),
      child: Column(
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
      ),
    );
  }
}
