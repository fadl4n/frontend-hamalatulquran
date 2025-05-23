import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/models/santri_model.dart';
import 'package:frontend_hamalatulquran/pages/evaluasi_murojaah/evaluasi_list_surat.dart';
import 'package:frontend_hamalatulquran/repositories/santri_repository.dart';
import 'package:frontend_hamalatulquran/widgets/appbar/custom_appbar.dart';

import '../../services/utils/search_util.dart';
import '../../widgets/search/search.dart';
import '../../widgets/tiles/santri_tile.dart';

class EvaluasiListSantri extends StatefulWidget {
  const EvaluasiListSantri({super.key});

  @override
  State<EvaluasiListSantri> createState() => _EvaluasiListSantriState();
}

class _EvaluasiListSantriState extends State<EvaluasiListSantri> {
  late Future<List<Santri>> futureSantri;
  List<Santri> santriListAsli = [];
  List<Santri> santriListFiltered = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureSantri = SantriRepository.getAll().then((listSantri) {
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
            santri.nama.toLowerCase().contains(key.toLowerCase()) ,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Evaluasi Muroja'ah", fontSize: 18.sp),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            // Search Bar
            SearchWithDivider(
              controller: searchController,
              onChanged: _filterSantri,
            ),
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
                                futureSantri = SantriRepository.getAll();
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
                              builder: (context) => EvaluasiListSurat(
                                santri: santri
                              ),
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