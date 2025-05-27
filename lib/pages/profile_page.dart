import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/user_profile.dart';
import 'package:frontend_hamalatulquran/services/env.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api/api_service.dart';
import '../services/auth/auth_service.dart';
import '../widgets/shimmer/data_detail_shimmer.dart';
import '../widgets/shimmer/profile_shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<ProfileModel>? _profileFuture;
  String? rawFotoProfil;

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
    await AuthService().logout();

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
        child: FutureBuilder<ProfileModel>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProfileShimmer();
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error?.toString() ?? "Gagal memuat data",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _profileFuture = ApiService().getProfile();
                      }),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            final profile = snapshot.data!;
            final nama = profile.nama;
            final identifier = profile.nip ?? profile.nisn ?? '';
            rawFotoProfil = profile.fotoProfil;
            final userRole =
                profile.role;
            final userGender =
                (profile.jenisKelamin == 2 || profile.jenisKelamin == "2")
                    ? "Perempuan"
                    : "Laki-laki";

            final isPengajar = profile.nip != null;
            final isSantri = profile.nisn != null;

            // Fix URL foto profil biar bisa diakses (contoh localhost emulator)
            String profilePict = "";
            if (rawFotoProfil != null && rawFotoProfil!.isNotEmpty) {
              profilePict = Environment.buildImageUrl(rawFotoProfil!);
            }

            // Kalau gak ada foto, pake default sesuai role + gender
            if (profilePict.isEmpty) {
              profilePict =
                  ""; // kosong biar kita pakai Image.asset di errorWidget
            }

            debugPrint("📸 Profile Data: $profile");
            debugPrint("🔗 Profile Image URL after fix: $profilePict");
            debugPrint("🧑 Role: $userRole, Gender: $userGender");

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
                                child: profilePict.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: profilePict,
                                        width: 110.r,
                                        height: 110.r,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const DataDetailShimmer(),
                                        errorWidget: (context, url, error) {
                                          // fallback ke asset default sesuai role & gender
                                          final fallback = ApiService
                                              .getDefaultAssetByRoleGender(
                                                  userRole, userGender);
                                          return Image.asset(
                                            fallback,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        ApiService.getDefaultAssetByRoleGender(
                                            userRole, userGender),
                                        fit: BoxFit.cover,
                                        width: 110.r,
                                        height: 110.r,
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
                        if (isPengajar) ...[
                          _buildMenuItem(
                            context,
                            Icons.visibility,
                            "Data Pengajar",
                            onTap: () {
                              print(
                                  "Navigating to /detail-pengajar with ID: ${profile.id}");
                              Navigator.pushNamed(
                                context,
                                '/detail-pengajar',
                                arguments: {
                                  'id': profile.id,
                                  'nama': profile.nama,
                                },
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
                                  "Navigating to /detail-santri with ID: ${profile.id}");
                              Navigator.pushNamed(
                                context,
                                '/detail-santri',
                                arguments: {
                                  'id': profile.id,
                                  'nama': profile.nama,
                                },
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
                // Navigate to change password page
                Navigator.pushNamed(context, "/change-password");
              }
            },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Row(
            children: [
              Icon(icon, color: Colors.green, size: 24.w),
              SizedBox(width: 15.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleLogout();
              },
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );
  }
}
