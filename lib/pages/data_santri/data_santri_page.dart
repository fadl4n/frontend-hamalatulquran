import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/detail_data_santri.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class DataSantriPage extends StatefulWidget {
  final int id;
  final String namaKelas;
  const DataSantriPage({super.key, required this.id, required this.namaKelas});

  @override
  State<DataSantriPage> createState() => _DataSantriPageState();
}

class _DataSantriPageState extends State<DataSantriPage> {
  late Future<List<Santri>> futureSantri;

  @override
  void initState() {
    super.initState();
    futureSantri = ApiService().fetchSantriByKelas(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 60.h,
        title: Text(
          "Data Santri Kelas ${widget.namaKelas}",
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
                          SizedBox(height: 10),
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
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
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
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDataSantri(id: santri.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              // Foto Santri
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey.shade300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: (santri.fotoSantri != null &&
                          santri.fotoSantri!.isNotEmpty &&
                          santri.fotoSantri!.startsWith("http"))
                      ? Image.network(
                          santri.fotoSantri!, // 🔗 Load dari URL kalau valid
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              santri.jenisKelamin == "Laki-Laki"
                                  ? "assets/ikhwan.png"
                                  : "assets/akhwat.png",
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          santri.jenisKelamin == "Laki-Laki"
                              ? "assets/ikhwan.png"
                              : "assets/akhwat.png",
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              SizedBox(width: 10.w),
              // Nama dan NISN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      santri.nama,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
