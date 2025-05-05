import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/data_detail_shimmer.dart';
import 'package:frontend_hamalatulquran/widgets/profile_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>>? _profileFuture;
  bool isPengajar = false;
  bool isSantri = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _profileFuture = ApiService().getProfile();
    });
  }

  Future<void> refreshProfile() async {
    setState(() {
      _profileFuture = ApiService().getProfile();
    });
  }

  Future<void> _handleLogout() async {
    await ApiService().logout(); // Panggil logout dari ApiService

    // Setelah logout, pindah ke halaman login
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Profile Anda", fontSize: 18.sp),
      body: RefreshIndicator(
        onRefresh: refreshProfile,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProfileShimmer();
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.containsKey("error")) {
              return Center(
                child: Text(
                  snapshot.data?["error"] ?? "Gagal memuat data",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final profile = snapshot.data!;
            final nama = profile['nama'] ?? 'Tidak ada Nama';
            final identifier =
                profile['nip'] ?? profile['nisn'] ?? 'Tidak ada NIP/NISN';
            final profilePict =
                profile['foto_profil'] ?? "https://via.placeholder.com/150";

            // Tentukan apakah pengguna adalah Pengajar atau Santri
            isPengajar = profile['nip'] != null;
            isSantri = profile['nisn'] != null;

            print("📸 Profile Data: $profile");

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80.h),
                Center(
                  child: Container(
                    width: 0.6.sw,
                    height: 300.h,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 55.r,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profilePict,
                                  width: 110.r,
                                  height: 110.r,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const DataDetailShimmer(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/user.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 10.w,
                              child: Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4.r,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 16.w,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          nama,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          identifier,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Center(
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Menampilkan menu sesuai dengan status login
                        if (isPengajar) ...[
                          _buildMenuItem(
                            context,
                            Icons.visibility,
                            "Data Pengajar",
                            onTap: () {
                              print(
                                  "Navigating to /detail-pengajar with ID: ${profile['id']}");
                              Navigator.pushNamed(
                                context,
                                '/detail-pengajar',
                                arguments: profile['id'],
                              );
                            },
                          ),
                        ] else if (isSantri) ...[
                          _buildMenuItem(
                            context,
                            Icons.visibility,
                            "Data Santri",
                            onTap: () {
                              print(
                                  "Navigating to /detail-santri with ID: ${profile['id']}");
                              Navigator.pushNamed(
                                context,
                                '/detail-santri',
                                arguments: profile['id'],
                              );
                            },
                          ),
                        ],
                        const Divider(),
                        _buildMenuItem(context, Icons.lock, "Ganti Kata Sandi"),
                        const Divider(),
                        _buildMenuItem(
                            context, Icons.logout_outlined, "Keluar"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap ??
            () {
              if (title == "Keluar") {
                _showExitDialog(context);
              } else if (title == "Ganti Kata Sandi") {
                Navigator.pushNamed(context, '/ganti-pw');
              }
            },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: Row(
            children: [
              Icon(icon, size: 22.w, color: Colors.black54),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Keluar Aplikasi",
              style: GoogleFonts.poppins(
                  fontSize: 16.sp, fontWeight: FontWeight.bold)),
          content: Text("Apakah Anda yakin ingin keluar?",
              style: GoogleFonts.poppins(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ✅ Tutup dialog
              child: Text("Batal",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w500)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // ✅ Tutup dialog dulu
                await _handleLogout();
              },
              child: Text("Keluar",
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
