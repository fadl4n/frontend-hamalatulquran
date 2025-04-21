import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/data_pengajar/detail_data_pengajar.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class DataPengajarPage extends StatefulWidget {
  const DataPengajarPage({super.key});

  @override
  State<DataPengajarPage> createState() => _DataPengajarPageState();
}

class _DataPengajarPageState extends State<DataPengajarPage> {
  late Future<List<Pengajar>>? _futurePengajar;

  @override
  void initState() {
    super.initState();
    _futurePengajar = ApiService().fetchPengajar();
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
          "Data Pengajar",
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
            // List Penajar PonPes Hamalatul Qur'an
            Expanded(
              child: _futurePengajar == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<Pengajar>>(
                      future: _futurePengajar,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          print("🛑 Error: ${snapshot.error}");
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Terjadi kesalahan: ${snapshot.error}"),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _futurePengajar =
                                          ApiService().fetchPengajar();
                                    });
                                  },
                                  child: const Text("Coba Lagi"),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Tidak ada Data Pengajar"),
                          );
                        }
                        List<Pengajar> pengajarList = snapshot.data!;
                        return ListView.builder(
                          itemCount: pengajarList.length,
                          itemBuilder: (context, index) {
                            return PengajarTile(pengajar: pengajarList[index]);
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class PengajarTile extends StatelessWidget {
  final Pengajar pengajar;
  const PengajarTile({super.key, required this.pengajar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDataPengajar(id: pengajar.id,),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.r),
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
                    child: (pengajar.fotoPengajar != null &&
                            pengajar.fotoPengajar!.isNotEmpty &&
                            pengajar.fotoPengajar!.startsWith("http"))
                        ? CachedNetworkImage(
                            imageUrl: pengajar.fotoPengajar!,
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
                              pengajar.jenisKelamin == "Laki-Laki"
                                  ? "assets/ikhwan.png"
                                  : "assets/akhwat.png",
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            pengajar.jenisKelamin == "Laki-Laki"
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengajar.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pengajar.nip,
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
    );
  }
}
