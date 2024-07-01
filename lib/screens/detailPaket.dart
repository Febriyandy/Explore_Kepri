import 'dart:async';
import 'dart:ui';

import 'package:explore_kepri/screens/datailPesanan.dart';
import 'package:explore_kepri/screens/paket.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailPaketPage extends StatefulWidget {
  final String id;

  const DetailPaketPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPaketPage> createState() => _DetailPaketPageState();
}

class _DetailPaketPageState extends State<DetailPaketPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('explore-kepri/paket_wisata');

  Map<dynamic, dynamic>? paketData;
  List<dynamic>? ulasanData;
  TextEditingController _reviewController = TextEditingController();
  double _ratingValue = 0.0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchPaketData();
    _fetchUlasanData();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  Future<void> _fetchPaketData() async {
    DatabaseEvent event = await _databaseReference.child(widget.id).once();
    var data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      setState(() {
        paketData = data;
      });
    }
  }

  void _hitungRating() {
    if (ulasanData != null && ulasanData!.isNotEmpty) {
      double totalRating = 0.0;
      for (var ulasan in ulasanData!) {
        totalRating += ulasan['nilai_bintang'];
      }
      double averageRating = totalRating / ulasanData!.length;
      DatabaseReference paketRef = FirebaseDatabase.instance
          .ref()
          .child('explore-kepri/paket_wisata/${widget.id}');
      paketRef.update({'rating': averageRating}).then((_) {
        print('Rating berhasil diupdate: $averageRating');
        _fetchPaketData();
      }).catchError((error) {
        print('Gagal mengupdate rating: $error');
      });
    } else {
      print('Tidak ada ulasan yang tersedia.');
    }
  }

  Future<void> _fetchUlasanData() async {
    DatabaseEvent event =
        await _databaseReference.child('${widget.id}/ulasan').once();
    var data = event.snapshot.value;

    if (data != null && data is Map) {
      List<dynamic> dataList = data.values.toList();

      setState(() {
        ulasanData = dataList;
      });
      _hitungRating();
    }
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const PaketPage(),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/back.svg',
                              color: blueColor, // assuming blueColor is defined
                              width: 30.0,
                              height: 30.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                          child: Text(
                            "Paket Wisata",
                            style: TextStyle(
                              color: darkColor, // assuming darkColor is defined
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
                  child: paketData == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 25.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    paketData!['images'][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          paketData!['nama_paket'],
                                          style: TextStyle(
                                            color: darkColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/lokasi.svg',
                                              // ignore: deprecated_member_use
                                              color:
                                                  darkColor, // assuming blueColor is defined
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              paketData!['kabupaten'],
                                              style: TextStyle(
                                                color: darkColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(right: 25.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        paketData!['rating'] != null
                                            ? paketData!['rating']
                                                .toStringAsFixed(1)
                                            : '-',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        ulasanData != null
                                            ? ulasanData!.length.toString()
                                            : '0',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        ')',
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
                              ],
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Destinasi Wisata",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              paketData!['destinasi'].length,
                                              (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Text(
                                                      '\u2022 ', // Bullet point character
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      paketData!['destinasi']
                                                          [index],
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Rangkaian Kegiatan",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              paketData!['rangkaian_kegiatan']
                                                  .length, (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Text(
                                                      '\u2022 ', // Bullet point character
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      paketData![
                                                              'rangkaian_kegiatan']
                                                          [index],
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Fasilitas",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              paketData!['fasilitas'].length,
                                              (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Text(
                                                      '\u2022 ', // Bullet point character
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      paketData!['fasilitas']
                                                          [index],
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Biaya",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              paketData!['biaya'].length,
                                              (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Text(
                                                      '\u2022 ', // Bullet point character
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      paketData!['biaya']
                                                          [index],
                                                      style: TextStyle(
                                                        color: darkColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Ulasan",
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ),


                            const SizedBox(height: 5),
                            ulasanData == null
                                ? const SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: ulasanData!.length,
                                        itemBuilder: (context, index) {
                                          return _buildUlasanCard(
                                              ulasanData![index]);
                                        },
                                      ),
                                    ),
                                  ),


                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
                              child: Container(
                                width: 200,
                                height: 45,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [darkColor, primary],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPesananPage(
                                            id: widget.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Pesan Sekarang",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//Fungsi untuk mendapatkan data ulasan
  Widget _buildUlasanCard(dynamic ulasan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: darkColor,
                        width: 3.0,
                      ),
                    ),
                    child: ClipOval(
                      child: ulasan['photoURL'] != null
                          ? Image.network(
                              ulasan['photoURL'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/profil.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/profil.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ulasan['displayName'] ?? 'Nama Pengguna',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < ulasan['nilai_bintang']
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                ulasan['deskripsi_ulasan'],
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
