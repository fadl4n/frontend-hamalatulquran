import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  String imgP = "assets/ustadz.png"; // Default sementara

  @override
  void initState() {
    super.initState();
    _loadProfileIcon();
  }

  Future<void> _loadProfileIcon() async {
    String defaultProfileIcon = await ApiService.getProfileIcon();
    if (mounted) {
      setState(() {
        imgP = defaultProfileIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 25,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          backgroundImage: AssetImage(imgP), // Langsung pakai default
        ),
      ),
    );
  }
}
