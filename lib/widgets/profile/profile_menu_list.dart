import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/widgets/profile/profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  final bool isPengajar;
  final bool isSantri;
  final Map<String, dynamic> profile;
  final VoidCallback onLogout;

  const ProfileMenuList({
    super.key,
    required this.isPengajar,
    required this.isSantri,
    required this.profile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black26,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          if (isPengajar)
            ProfileMenuItem(
              icon: Icons.visibility,
              title: "Data Pengajar",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail-pengajar',
                  arguments: {
                    'id': profile['id'],
                    'nama': profile['nama'],
                  },
                );
              },
            ),
          if (isSantri)
            ProfileMenuItem(
              icon: Icons.visibility,
              title: "Data Santri",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail-santri',
                  arguments: {
                    'id': profile['id'],
                    'nama': profile['nama'],
                  },
                );
              },
            ),
          const Divider(),
          ProfileMenuItem(
            icon: Icons.lock,
            title: "Ganti Kata Sandi",
            onTap: () => Navigator.pushNamed(context, '/ganti-pw'),
          ),
          const Divider(),
          ProfileMenuItem(
            icon: Icons.logout_outlined,
            title: "Keluar",
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
