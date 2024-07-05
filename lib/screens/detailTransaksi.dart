import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:explore_kepri/screens/transaksi.dart'; 
import 'package:explore_kepri/utils/theme.dart'; 

class DetailTransaksiPage extends StatefulWidget {
  final String id;

  const DetailTransaksiPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {

//Mendapatkan data trabsaksi dari firebase
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('explore-kepri/transaksi');

  Map<dynamic, dynamic>? transaksiData;
  String? _userId;
  String? _statusPembayaran = '';

  @override
  void initState() {
    super.initState();
    _fetchTransaksiData();
    _getCurrentUser();
    _getStatusTransaksi();
  }

//Fungsi mendapatkan data user yang sedang login
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

//Fungsi untuk mendapatkan data transaksi
  Future<void> _fetchTransaksiData() async {
    DatabaseEvent event = await _databaseReference.child(widget.id).once();
    var data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      setState(() {
        transaksiData = data;
        if (transaksiData!['total_harga'] is String) {
          transaksiData!['total_harga'] =
              int.parse(transaksiData!['total_harga']);
        }
      });
    }
  }

//Fungsi untuk mengupdate status transaksi
  Future<void> _getStatusTransaksi() async {
    try {
      String url = 'http://localhost:7600/Status/${widget.id}';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _statusPembayaran = data['transaction_status'];
          transaksiData!['status_pembayaran'] = _statusPembayaran;
        });
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Error fetching status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat("#,###");

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
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 140,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 85, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TransaksiPage(),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/back.svg',
                                color:
                                    blueColor, // Sesuaikan dengan warna yang Anda tentukan
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70, 85, 0, 0),
                            child: Text(
                              "Detail Transaksi",
                              style: TextStyle(
                                color:
                                    darkColor, // Sesuaikan dengan warna yang Anda tentukan
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

//Widget untuk menampilkan detail transaksi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 700,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/bgtransaksi.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (transaksiData != null)
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 360,
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: Image.network(
                                          transaksiData!['photoUrlPaket'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Text(
                                    transaksiData!['nama_paket'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: darkColor,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Nama',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          transaksiData!['nama_pengguna'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Email',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          transaksiData!['email'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tanggal',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          transaksiData!['tanggal_berwisata'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Jumlah Orang',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          '${transaksiData!['jumlah_orang']} Orang',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Status Perjalanan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          transaksiData!['status_pembayaran'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Detail Transaksi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: darkColor,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID Transaksi',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              color: darkColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              transaksiData!['Order_Id'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: darkColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Total Biaya',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              color: darkColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              "Rp ${formatter.format(transaksiData!['total_harga'])}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: darkColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Status Pembayaran',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              color: darkColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              transaksiData![
                                                  'status_pembayaran'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                color: darkColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Silahkan hubungin nomor di bawah ini untuk memberikan lokasi penjemputan.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                      color: darkColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(const ClipboardData(
                                            text: "0851-6259-8308"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Copied to Clipboard"),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 13.5,
                                          horizontal:
                                              16.0, // Adjust padding to accommodate the icon
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [darkColor, primary],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Centering content horizontally
                                          children: [
                                            Icon(
                                              Icons.copy,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            SizedBox(
                                                width:
                                                    8.0), // Adjust spacing between icon and text
                                            Center(
                                              child: Text(
                                                "0851-6259-8308",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (transaksiData == null)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
