import 'dart:ui';
import 'package:explore_kepri/screens/detailPaket.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';

class PaketPage extends StatefulWidget {
  const PaketPage({super.key});

  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
//Fungsi mendapatkan data dari firebase
  final DatabaseReference _paketRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/paket_wisata');

  List<Map<dynamic, dynamic>> paketList = [];
  String searchQuery = '';
  List<String> kabupatenList = [
    'Kota Tanjungpinang',
    'Kabupaten Bintan',
    'Kabupaten Lingga',
    'Kabupaten Natuna',
    'Kabupaten Karimun',
    'Kabupaten Anambas',
    'Kota Batam',
  ];
  List<String> selectedKabupaten = [];


//Fungsi untuk menampilkan data dari firebase
  @override
  void initState() {
    super.initState();
    _paketRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<dynamic, dynamic>> tempPaketList = [];
        data.forEach((key, value) {
          var paket = value as Map<dynamic, dynamic>;
          paket['id'] = key;
          tempPaketList.add(paket);
        });
        setState(() {
          paketList = tempPaketList;
        });
      } else {
        print('Data from Firebase is null or empty');
      }
    });
  }

//fungsi fiter berdasarkan kabupaten  dan pencarian berdasarkan nama paker
  List<Map<dynamic, dynamic>> get filteredPaketList {
    return paketList.where((paket) {
      final namaPaket = paket['nama_paket'].toString().toLowerCase();
      final kabupaten = paket['kabupaten'].toString();
      final searchLower = searchQuery.toLowerCase();
      return namaPaket.contains(searchLower) &&
          (selectedKabupaten.isEmpty || selectedKabupaten.contains(kabupaten));
    }).toList();
  }

//popup untuk menampilkan filter
  void _showFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Filter Berdasarkan Kab/Kota",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: darkColor,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: kabupatenList.map((kabupaten) {
                          return ChoiceChip(
                            label: Text(kabupaten),
                            selected: selectedKabupaten.contains(kabupaten),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedKabupaten.add(kabupaten);
                                } else {
                                  selectedKabupaten.remove(kabupaten);
                                }
                              });
                            },
                            selectedColor: blueColor,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: darkColor),
                            ),
                            labelStyle: TextStyle(
                              color: selectedKabupaten.contains(kabupaten)
                                  ? Colors.white
                                  : darkColor,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedKabupaten.clear();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: blueColor,
                              ),
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [darkColor, primary],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Terapkan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latarbelakang.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const LandingPage()));
                            },
                            child: SvgPicture.asset(
                              'assets/icons/back.svg',
                              color: blueColor,
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              'assets/images/Logo.png',
                              width: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                style: TextStyle(
                                  color: darkColor,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Yuk cari paket wisata impianmu',
                                  hintStyle: TextStyle(
                                    color: grayColor,
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                  ),
                                  suffixIcon:
                                      Icon(Icons.search, color: darkColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Paket Wisata",
                                style: TextStyle(
                                  color: darkColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                          child: GestureDetector(
                            onTap: _showFilterPopup,
                            child: SvgPicture.asset(
                              'assets/icons/filter.svg',
                              color: blueColor,
                              width: 25.0,
                              height: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

//Widget menampilkan data paket wisata 
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            var paket = filteredPaketList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: 400,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.white.withOpacity(0.3),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15.0),
                                          child: Container(
                                            width: 140,
                                            height: 150,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: AspectRatio(
                                                aspectRatio: 1.0,
                                                child: Image.network(
                                                  paket['images'][0],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 15, 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  paket['nama_paket'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.bold,
                                                    color: darkColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Nikmati Paket Wisata durasi ${paket['lama_kegiatan']}. Dengan biaya mulai dari ${paket['rentang_harga']}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Poppins",
                                                    color: darkColor,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Container(
                                                        width: 110,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              darkColor,
                                                              primary
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: Center(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailPaketPage(
                                                                    id: paket[
                                                                        'id'],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              "Lihat Detail",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: filteredPaketList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
