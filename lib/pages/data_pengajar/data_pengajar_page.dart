import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/data_pengajar/detail_data_pengajar.dart';
import 'package:frontend_hamalatulquran/services/api_service.dart';
import 'package:frontend_hamalatulquran/services/search_util.dart';
import 'package:frontend_hamalatulquran/widgets/custom_appbar.dart';
import 'package:frontend_hamalatulquran/widgets/pengajar_tile.dart';
import 'package:frontend_hamalatulquran/models/pengajar_model.dart';
import 'package:frontend_hamalatulquran/widgets/search.dart';

class DataPengajarPage extends StatefulWidget {
  const DataPengajarPage({super.key});

  @override
  State<DataPengajarPage> createState() => _DataPengajarPageState();
}

class _DataPengajarPageState extends State<DataPengajarPage> {
  late Future<List<Pengajar>>? _futurePengajar;
  List<Pengajar> pengajarListAsli = [];
  List<Pengajar> pengajarListFiltered = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futurePengajar = ApiService.fetchPengajar().then((listPengajar) {
      pengajarListAsli = listPengajar;
      pengajarListFiltered = listPengajar;
      return listPengajar;
    });
  }

  void _filterPengajar(String keyword) {
    setState(() {
      pengajarListFiltered = SearchUtil.filterList<Pengajar>(
        pengajarListAsli,
        keyword,
        (santri, key) => santri.nama.toLowerCase().contains(key.toLowerCase()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Data Pengajar", fontSize: 18.sp),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SearchWithDivider(
                controller: searchController, onChanged: _filterPengajar),
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
                                          ApiService.fetchPengajar();
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
                        if (pengajarListAsli.isEmpty) {
                          pengajarListAsli = snapshot.data!;
                          pengajarListFiltered = pengajarListAsli;
                        }
                        return ListView.builder(
                          itemCount: pengajarListFiltered.length,
                          itemBuilder: (context, index) {
                            final pengajar = pengajarListFiltered[index];
                            return PengajarTile(
                              pengajar: pengajar,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailDataPengajar(
                                      id: pengajar.id,
                                      nama: pengajar.nama,
                                    ),
                                  ),
                                );
                              },
                            );
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
