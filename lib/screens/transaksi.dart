import 'dart:ui';
import 'package:explore_kepri/screens/detailPaket.dart';
import 'package:explore_kepri/screens/detailTransaksi.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
//Mendapatkan data transaksi dari firebase
  final DatabaseReference _transaksiRef =
      FirebaseDatabase.instance.ref().child('explore-kepri/transaksi');

  List<Map<dynamic, dynamic>> tempTransaksiList = [];

  @override
  void initState() {
    super.initState();
    _fetchUserTransactions();
  }

//mendapatkan data transaksi berdasarkan id user yang sedang login
  Future<void> _fetchUserTransactions() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _transaksiRef
            .orderByChild('userId')
            .equalTo(user.uid)
            .onValue
            .listen((event) {
          var snapshot = event.snapshot;
          var data = snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            tempTransaksiList.clear();
            data.forEach((key, value) {
              var transaksi = value as Map<dynamic, dynamic>;
              transaksi['id'] = key;
              tempTransaksiList.add(transaksi);
            });
            setState(() {
              tempTransaksiList;
            });
          } else {
            print('No transactions found for the current user.');
          }
        });
      } else {
        print('User is not authenticated.');
      }
    } catch (error) {
      print('Error fetching user transactions: $error');
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
                                "Daftar Transaksi",
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
                  ],
                ),
              ),

//widget untuk menampilkan data transaksi
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            var transaksi = tempTransaksiList[index];
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
                                                  transaksi['photoUrlPaket'],
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
                                                  transaksi['nama_paket'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.bold,
                                                    color: darkColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Status Pembayaran \n${transaksi['status_pembayaran']}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.bold,
                                                    color: darkColor,
                                                  ),
                                                ),
                                                Text(
                                                  'ID Transaksi \n${transaksi['Order_Id']}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w700,
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
                                                                          DetailTransaksiPage(
                                                                    id: transaksi[
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
                          childCount: tempTransaksiList.length,
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
