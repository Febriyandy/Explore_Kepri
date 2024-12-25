import 'dart:async';
import 'dart:ui';

import 'package:explore_kepri/screens/galeriList.dart';
import 'package:explore_kepri/screens/galeri_detail.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({Key? key}) : super(key: key);

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
//Mendapatkan data galeri dari firebase
  final DatabaseReference _galeriRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/galeri');

  List<Map<dynamic, dynamic>> galeriList = [];
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

//Fungsi untuk filter foto dari galeri berdasarkan lokasi kabupaten
  List<Map<dynamic, dynamic>> get filteredGaleriList {
    return galeriList.where((galeri) {
      final kabupaten = galeri['kabupaten'].toString();
      return selectedKabupaten.isEmpty || selectedKabupaten.contains(kabupaten);
    }).toList();
  }

Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
    return false;
  }

//Widget popup untuk melakukan filter
  void _showFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
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
                        return StatefulBuilder(
                          builder: (context, setState) {
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
                                side: BorderSide(
                                  color: darkColor,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: selectedKabupaten.contains(kabupaten)
                                    ? Colors.white
                                    : darkColor,
                              ),
                            );
                          },
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//Fungsi untuk mendapatkan data gaelri dari firebase
  @override
  void initState() {
    super.initState();
    _galeriRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<dynamic, dynamic>> tempGaleriList = [];
        data.forEach((key, value) {
          var galeri = value as Map<dynamic, dynamic>;
          galeri['id'] = key;
          tempGaleriList.add(galeri);
        });
        setState(() {
          galeriList = tempGaleriList;
        });
      } else {
        print('Data from Firebase is null or empty');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                            padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
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
                            padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
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
                                  "Galeri",
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
                          Row(
                            children: [
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                                child: GestureDetector(
                                  onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const GaleriListPage()));
                              },
                                  child: SvgPicture.asset(
                                    'assets/icons/list.svg',
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
                    ],
                  ),
                ),
      
      //Widget mendampilkan data galeri dalam bentuk grid
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                 Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GaleriDetailPage(galeri: filteredGaleriList[index]),
                            ),
                          );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      filteredGaleriList[index]['urlPhoto'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: filteredGaleriList.length,
                          ),
                        ),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}