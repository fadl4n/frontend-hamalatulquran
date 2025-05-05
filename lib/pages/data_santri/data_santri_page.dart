import 'package:flutter/material.dart';
import 'package:frontend_hamalatulquran/repositories/santri_repository.dart';
import 'package:frontend_hamalatulquran/services/search_util.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/santri_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/data_santri/detail_data_santri.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/widgets/search.dart';

class DataSantriPage extends StatefulWidget {
  final int id;
  final String namaKelas;
  const DataSantriPage({super.key, required this.id, required this.namaKelas});

  @override
  State<DataSantriPage> createState() => _DataSantriPageState();
}

class _DataSantriPageState extends State<DataSantriPage> {
  late Future<List<Santri>> _futureSantri;
  List<Santri> santriListAsli = [];
  List<Santri> santriListFiltered = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureSantri = SantriRepository.getbyKelasId(widget.id).then((listSantri) {
      santriListAsli = listSantri;
      santriListFiltered = listSantri;
      return listSantri;
    });
  }

  void _filterSantri(String keyword) {
    setState(() {
      santriListFiltered = SearchUtil.filterList<Santri>(
        santriListAsli,
        keyword,
        (santri, key) =>
            santri.nama.toLowerCase().contains(key.toLowerCase()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: "Data Santri Kelas ${widget.namaKelas}", fontSize: 16.sp),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            // Search Bar
            SearchWithDivider(
                controller: searchController, onChanged: _filterSantri),
            // List Santri
            Expanded(
              child: FutureBuilder<List<Santri>>(
                future: _futureSantri,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("🛑 Error: ${snapshot.error}");
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Terjadi kesalahan: ${snapshot.error}"),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _futureSantri =
                                    SantriRepository.getbyKelasId(widget.id);
                              });
                            },
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada data santri."));
                  }

                  if (santriListAsli.isEmpty) {
                    santriListAsli = snapshot.data!;
                    santriListFiltered = santriListAsli;
                  }
                  return ListView.builder(
                    itemCount: santriListFiltered.length,
                    itemBuilder: (context, index) {
                      final santri = santriListFiltered[index];
                      return SantriTile(
                        santri: santri,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailDataSantri(
                                  id: santri.id, nama: santri.nama),
                            ),
                          );
                        },
                      );
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
