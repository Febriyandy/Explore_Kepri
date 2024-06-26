import 'dart:ui';
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
  @override
  void initState() {
    super.initState();
    _destinasiRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic,
          dynamic>?; // Tambahkan tanda tanya (?) setelah snapshot.value
      if (data != null) {
        List<Map<dynamic, dynamic>> tempDestinasiList = [];
        data.forEach((key, value) {
          tempDestinasiList.add(value as Map<dynamic, dynamic>);
        });
        setState(() {
          destinasiList = tempDestinasiList;
        });
      } else {
        // Handle case when snapshot.value is null or empty
        print('Data from Firebase is null or empty');
      }
    });
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                // Header with Back button and Logo
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
                          // ignore: deprecated_member_use
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
                // Search Bar
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
                              suffixIcon: Icon(Icons.search, color: darkColor),
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
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
                      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/icons/filter.svg',
                          // ignore: deprecated_member_use
                          color: blueColor,
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
                // Destinasi Cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                    const  EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  childAspectRatio: 0.8, // Ratio aspect untuk gambar
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: destinasiList.map((destinasi) {
                    return  Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: AspectRatio(
                              aspectRatio:
                                  0.8, // Sesuaikan dengan childAspectRatio di GridView
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
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                height: 55,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
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
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height:
                      100, // Padding bawah agar konten tidak tertutup oleh bottom navigation
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
