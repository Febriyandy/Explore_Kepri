import 'dart:async';
import 'dart:ui';
import 'package:explore_kepri/screens/detailPaket.dart';
import 'package:explore_kepri/screens/pembayaran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailPesananPage extends StatefulWidget {
  final String id;

  const DetailPesananPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('explore-kepri/paket_wisata');

  Map<dynamic, dynamic>? paketData;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _jumlahOrangController = TextEditingController();
  TextEditingController _whatsappController = TextEditingController();
  String? _userId;
  int jumlahOrang = 0;
  int hargaPerOrang = 0;
  int totalPembayaran = 0;

  @override
  void initState() {
    super.initState();
    _fetchPaketData();
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

Future<void> _sendTransactionData() async {
  try {
    // Pastikan data yang diperlukan sudah ada sebelum navigasi
    if (FirebaseAuth.instance.currentUser != null && paketData != null) {
      // Navigasi ke halaman pembayaran dengan membawa data yang diperlukan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranPage(
            id: widget.id,
            paketData: paketData,
            date: _dateController.text,
            jumlahOrang: jumlahOrang,
            totalPembayaran: totalPembayaran,
          ),
        ),
      );
    } else {
      throw Exception('User data or package data is not available.');
    }
  } catch (error) {
    print('Error sending transaction data: $error');
  }
}


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void calculateTotalPembayaran() {
    if (paketData != null) {
      switch (paketData!['lama_kegiatan']) {
        case '1 Hari':
          if (jumlahOrang >= 2 && jumlahOrang <= 3) {
            hargaPerOrang = 400000;
          } else if (jumlahOrang >= 4 && jumlahOrang <= 6) {
            hargaPerOrang = 350000;
          } else if (jumlahOrang >= 7 && jumlahOrang <= 11) {
            hargaPerOrang = 300000;
          }
          break;
        case '2 Hari':
          if (jumlahOrang >= 2 && jumlahOrang <= 3) {
            hargaPerOrang = 600000;
          } else if (jumlahOrang >= 4 && jumlahOrang <= 6) {
            hargaPerOrang = 550000;
          } else if (jumlahOrang >= 7 && jumlahOrang <= 11) {
            hargaPerOrang = 500000;
          }
          break;
        case '3 Hari':
          if (jumlahOrang >= 2 && jumlahOrang <= 3) {
            hargaPerOrang = 800000;
          } else if (jumlahOrang >= 4 && jumlahOrang <= 6) {
            hargaPerOrang = 750000;
          } else if (jumlahOrang >= 7 && jumlahOrang <= 11) {
            hargaPerOrang = 700000;
          }
          break;
        default:
          break;
      }

      setState(() {
        totalPembayaran = hargaPerOrang * jumlahOrang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat("#,###"); // Format untuk menambahkan pemisah titik

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
                      height: 280,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 85, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailPaketPage(id: widget.id),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/back.svg',
                                color:
                                    blueColor, // assuming blueColor is defined
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70, 85, 0, 0),
                            child: Text(
                              "Detail Pemesanan",
                              style: TextStyle(
                                color:
                                    darkColor, // assuming darkColor is defined
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 120.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: paketData != null &&
                                              paketData!['images'] != null &&
                                              paketData!['images'].isNotEmpty
                                          ? Image.network(
                                              paketData!['images'][0],
                                              fit: BoxFit.cover,
                                            )
                                          : Container(), // Handle if image is not available
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      paketData != null
                                          ? 'Paket Wisata \n${paketData!['nama_paket']}'
                                          : 'Paket Wisata', // Handle if paketData is null
                                      style: TextStyle(
                                        color: darkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        paketData != null
                                            ? 'Lama Kegiatan : ${paketData!['lama_kegiatan']}'
                                            : 'Lama Kegiatan :', // Handle if paketData is null
                                        style: TextStyle(
                                          color: darkColor,
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                      height:
                          20), // Tambahkan jarak antara kotak putih dan teks "Destinasi Wisata"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Formulir Pemesanan",
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 0, 10),
                                    child: Text(
                                      "Tanggal",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets
                                              .symmetric(
                                          vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none),
                                      ),
                                      hintText: "Pilih Tanggal",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white
                                          .withOpacity(0.5),
                                      filled: true,
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                        borderSide: BorderSide(
                                            color: darkColor,
                                            width: 2.0),
                                      ),
                                      
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20, 0, 10),
                                    child: Text(
                                      "Jumlah Orang",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller:
                                        _jumlahOrangController,
                                    keyboardType:
                                        TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        jumlahOrang = int.tryParse(
                                                value) ??
                                            0;
                                        calculateTotalPembayaran();
                                      });
                                    },
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets
                                              .symmetric(
                                          vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                        borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none),
                                      ),
                                      hintText: "Min 2, Max 11",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white
                                          .withOpacity(0.5),
                                      filled: true,
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                        borderSide: BorderSide(
                                            color: darkColor,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20, 0, 10),
                                    child: Text(
                                      "Nomor WhatsApp",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _whatsappController,
                                    keyboardType:
                                        TextInputType.phone,
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets
                                              .symmetric(
                                          vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                        borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none),
                                      ),
                                      hintText: "628.....",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white
                                          .withOpacity(0.5),
                                      filled: true,
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                        borderSide: BorderSide(
                                            color: darkColor,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            color: darkColor,
                          ),
                        ),
                        Text(
                          "Rp ${formatter.format(totalPembayaran)}", // Menggunakan formatter untuk menambahkan pemisah titik
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            darkColor,
                            primary
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _sendTransactionData(); // Call method to send data
                          },
                          borderRadius:
                              BorderRadius.circular(10.0),
                          child: const Center(
                            child:  Text(
                              "Bayar Sekarang",
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
