import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60, // Sesuaikan tinggi dari atas
      right: 25, // Geser ke kanan
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
        child: const CircleAvatar(
          radius: 25,
          backgroundImage:
              AssetImage('assets/profile.jpg'), // Ganti dengan path foto profil
        ),
      ),
    );
  }
}
