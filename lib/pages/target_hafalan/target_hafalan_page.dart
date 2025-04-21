import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/target_hafalan/target_hafalan_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TargetHafalanPage extends StatefulWidget {
  const TargetHafalanPage({super.key});

  @override
  State<TargetHafalanPage> createState() => _TargetHafalanPageState();
}

class _TargetHafalanPageState extends State<TargetHafalanPage> {
  late Future<List<Santri>> futureSantri;

  @override
  void initState() {
    super.initState();
    futureSantri = ApiService().fetchSantri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.r),
            ),
          ),
        ),
        title: Text(
          "Target Hafalan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20.r),
          child: Center(
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20.w),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),

            // List Santri
            Expanded(
              child: FutureBuilder<List<Santri>>(
                future: futureSantri,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Terjadi kesalahan: ${snapshot.error}"),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                futureSantri = ApiService().fetchSantri();
                              });
                            },
                            child: Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada data santri."));
                  }

                  List<Santri> santriList = snapshot.data!;
                  return ListView.builder(
                    itemCount: santriList.length,
                    itemBuilder: (context, index) {
                      return SantriTile(santri: santriList[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔥 Custom Widget untuk ListTile Santri
class SantriTile extends StatelessWidget {
  final Santri santri;
  const SantriTile({super.key, required this.santri});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TargetHafalanUser(
                  nisn: santri.nisn,
                  nama: santri.nama,
                  kelas: santri.kelasNama,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(15.r),
          child: Ink(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(2, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar with Border
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade300, Colors.green.shade400],
                    ),
                  ),
                  padding: EdgeInsets.all(2.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: (santri.fotoSantri != null &&
                              santri.fotoSantri!.isNotEmpty &&
                              santri.fotoSantri!.startsWith("http"))
                          ? CachedNetworkImage(
                              imageUrl: santri.fotoSantri!,
                              width: 46.w,
                              height: 46.w,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 46.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                santri.jenisKelamin == "Laki-Laki"
                                    ? "assets/ikhwan.png"
                                    : "assets/akhwat.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              santri.jenisKelamin == "Laki-Laki"
                                  ? "assets/ikhwan.png"
                                  : "assets/akhwat.png",
                              width: 46.w,
                              height: 46.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Nama & Info Santri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        santri.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${santri.kelasNama} • ${santri.nisn}",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.w, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
