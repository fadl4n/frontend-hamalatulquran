import 'package:flutter/material.dart';
import '../pages/profile_page.dart'; // Pastikan path ini benar

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 25, // Sesuaikan tinggi dari atas
      right: 25, // Geser ke kanan
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()), // Ganti dengan halaman profil
          );
        },
        child: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/profile.jpg'), // Ganti dengan path foto profil
        ),
      ),
    );
  }
}
