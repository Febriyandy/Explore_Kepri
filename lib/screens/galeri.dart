import 'dart:ui';

import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
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
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 14,
                              fontFamily: "Poppins",
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari foto',
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
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Galeri Page'),
                      // Tambahkan konten lainnya di sini
                    ],
                  ),
                ),
                SizedBox(height: 100), // Padding bawah agar konten tidak tertutup oleh bottom navigation
              ],
            ),
          ),
        ],
      ),
    );
  }
}
