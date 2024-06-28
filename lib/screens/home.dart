import 'dart:ui';

import 'package:explore_kepri/screens/destinasi.dart';
import 'package:explore_kepri/screens/detailDestinasi.dart';
import 'package:explore_kepri/screens/galeri.dart';
import 'package:explore_kepri/screens/paket.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user =
      FirebaseAuth.instance.currentUser; // Mendapatkan pengguna saat ini

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
                ), // Padding untuk status bar
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: darkColor,
                            width: 3.0,
                          ),
                        ),
                        child: ClipOval(
                          child: user?.photoURL != null
                              ? Image.network(
                                  user!.photoURL!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/profil.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<User?>(
                            future:
                                FirebaseAuth.instance.authStateChanges().first,
                            builder: (BuildContext context,
                                AsyncSnapshot<User?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                );
                              } else {
                                user = snapshot.data;
                                String displayName =
                                    user?.displayName ?? 'Guest';
                                return Text(
                                  'Hi, $displayName',
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                );
                              }
                            },
                          ),
                          // Tambahkan konten lainnya di sini
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const DestinasiPage()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/destinasi.png',
                                  height: 53,
                                ), // Tambahkan jarak antara gambar dan teks
                                 Text(
                                  "Destinasi Wisata",
                            textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), 
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const PaketPage()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Image.asset(
                                    'assets/images/paket.png',
                                    height: 53,
                                  ),
                                ), // Tambahkan jarak antara gambar dan teks
                                 Text(
                                  "Paket Wisata",
                            textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), 
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const GaleriPage()));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Image.asset(
                                    'assets/images/galeri.png',
                                    height: 53,
                                  ),
                                ), // Tambahkan jarak antara gambar dan teks
                                 Text(
                                  "Galeri Wisata",
                            textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 100,
                ), // Padding bawah agar konten tidak tertutup oleh bottom navigation
              ],
            ),
          ),
        ],
      ),
    );
  }
}
