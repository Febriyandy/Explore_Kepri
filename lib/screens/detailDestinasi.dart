import 'dart:ui';

import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailDestinasiPage extends StatefulWidget {
  const DetailDestinasiPage({super.key});

  @override
  State<DetailDestinasiPage> createState() => _DetailDestinasiPageState();
}

class _DetailDestinasiPageState extends State<DetailDestinasiPage> {
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
            )),
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
                          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                          child: Text(
                            "Destinasi Wisata",
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/images/cover1.jpg',
                          width: 500,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Nama Destinasi",
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/lokasi.svg',
                            color: blueColor,
                            width: 15.0,
                            height: 15.0,
                          ),
                          Text(
                            "Kabupaten",
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Deskripsi",
                                  style: TextStyle(
                                color: darkColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Poppins",
                                                            ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Alamat",
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Alamat",
                                  style: TextStyle(
                                color: darkColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Poppins",
                                                            ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
