import 'dart:ui';
import 'package:explore_kepri/screens/destinasi.dart';
import 'package:explore_kepri/screens/detailDestinasi.dart';
import 'package:explore_kepri/screens/detailPaket.dart';
import 'package:explore_kepri/screens/galeri.dart';
import 'package:explore_kepri/screens/paket.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;

//fungsi untuk mendapatkan data destinasi
  final DatabaseReference _destinasiRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/destinasi');

//Fungsi mendapatkan data paket wisata dari firebase
  final DatabaseReference _paketRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/paket_wisata');

  List<Map<dynamic, dynamic>> paketList = [];
  List<Map<dynamic, dynamic>> destinasiList = [];
  String searchQuery = '';

  @override
  void initState() {

//fungsi untuk mendapatkan data destinasi rekomendasi berdasarkan nilai rating tertinggi
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

        tempDestinasiList.sort((a, b) {
          double ratingA = (a['rating'] ?? 0).toDouble();
          double ratingB = (b['rating'] ?? 0).toDouble();
          return ratingB.compareTo(ratingA);
        });

        setState(() {
          destinasiList = tempDestinasiList.take(6).toList();
        });
      } else {
        print('Data from Firebase is null or empty');
      }
    });

//fungsi untuk mendapatkan data paket wisata rekomendasi berdasarkan nilai rating tertinggi
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

        tempPaketList.sort((a, b) {
          double ratingA = (a['rating'] ?? 0).toDouble();
          double ratingB = (b['rating'] ?? 0).toDouble();
          return ratingB.compareTo(ratingA);
        });

        setState(() {
          paketList = tempPaketList.take(6).toList();
        });
      } else {
        print('Data from Firebase is null or empty');
      }
    });
  }

//fungsi untuk pencarian berdasarkan nama destinasi
  List<Map<dynamic, dynamic>> get filteredDestinasiList {
    // Filter destinasiList berdasarkan searchQuery
    var filteredList = destinasiList.where((destinasi) {
      final namaTempat = destinasi['nama_tempat'].toString().toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return namaTempat.contains(searchLower);
    }).toList();

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
          // Logo Section
          Positioned(
            top: 60,
            right: 20,
            child: Image.asset(
              'assets/images/Logo.png',
              width: 150,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 16),
                    FutureBuilder<User?>(
                      future: FirebaseAuth.instance.authStateChanges().first,
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
                          String displayName = user?.displayName ?? 'Guest';
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
                  ],
                ),
              ),

// widget kolom pencarian
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
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
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

 // widget menu utama
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

// Menu Destinasi
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const DestinasiPage(),
                          ),
                        );
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
                              ),
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

// Menu Paket Wisata
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PaketPage(),
                          ),
                        );
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Image.asset(
                                  'assets/images/paket.png',
                                  height: 53,
                                ),
                              ),
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

// Menu Galeri Wisata
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const GaleriPage(),
                          ),
                        );
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Image.asset(
                                  'assets/images/galeri.png',
                                  height: 53,
                                ),
                              ),
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rekomendasi Destinasi",
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
            ],
          ),

// Widget menampilkan destinasi wisata rekomendasi
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.43, // Adjust this value as needed
            left: 0,
            right: 0,
            child: Container(
              height: 200, 
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: filteredDestinasiList.length,
                itemBuilder: (BuildContext context, int index) {
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
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20.0), 
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 0.8,
                              child: Image.network(
                                destinasi['images'][0],
                                fit: BoxFit.cover,
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
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

//Teks Rekomendasi Paket wisata
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 330, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rekomendasi Paket Wisata",
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

//Widget menampilkan rekomendasi paket wisata berdasarkan nilai rating tertinggi
          Positioned(
            top: 605,
            left: 0,
            right: 0,
            child: Container(
              height: 173,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: paketList.length,
                itemBuilder: (context, index) {
                  var paket = paketList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 333,
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
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 15, 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          // Menampilkan rating paket wisata
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 11, 0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  paket['rating'] != null
                                                      ? paket['rating']
                                                          .toStringAsFixed(1)
                                                      : '-',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkColor,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Container(
                                              width: 110,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [darkColor, primary],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailPaketPage(
                                                          id: paket['id'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Lihat Detail",
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
