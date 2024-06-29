import 'dart:ui';
import 'package:explore_kepri/screens/detailDestinasi.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';

class DestinasiPage extends StatefulWidget {
  const DestinasiPage({super.key});

  @override
  State<DestinasiPage> createState() => _DestinasiPageState();
}

class _DestinasiPageState extends State<DestinasiPage> {
  final DatabaseReference _destinasiRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/destinasi');

  List<Map<dynamic, dynamic>> destinasiList = [];
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

  @override
  void initState() {
    super.initState();
    _destinasiRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<dynamic, dynamic>> tempDestinasiList = [];
        data.forEach((key, value) {
          var destinasi = value as Map<dynamic, dynamic>;
          destinasi['id'] = key;
          tempDestinasiList.add(destinasi);
        });
        setState(() {
          destinasiList = tempDestinasiList;
        });
      } else {
        print('Data from Firebase is null or empty');
      }
    });
  }

  List<Map<dynamic, dynamic>> get filteredDestinasiList {
    return destinasiList.where((destinasi) {
      final namaTempat = destinasi['nama_tempat'].toString().toLowerCase();
      final kabupaten = destinasi['kabupaten'].toString();
      final searchLower = searchQuery.toLowerCase();
      return namaTempat.contains(searchLower) &&
          (selectedKabupaten.isEmpty || selectedKabupaten.contains(kabupaten));
    }).toList();
  }

  void _showFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color:
                Colors.white.withOpacity(0.1), // Adding white blur background
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
                                borderRadius: BorderRadius.circular(
                                    30.0), // Rounded border
                                side: BorderSide(
                                    color:
                                        darkColor), // Ganti darkColor dengan warna yang Anda inginkan
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
                                  hintText: 'Yuk cari destinasi tujuanmu',
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
                                "Destinasi",
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
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            var destinasi = filteredDestinasiList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailDestinasiPage(
                                      id: destinasi['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: AspectRatio(
                                        aspectRatio: 0.8,
                                        child: Image.network(
                                          destinasi['images'][0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Container(
                                          height: 55,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 10.0,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  destinasi['nama_tempat'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  destinasi['kabupaten'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: filteredDestinasiList.length,
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
    );
  }
}
