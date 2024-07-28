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
  //Menghubungkan ke realtime database
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('explore-kepri/transaksi');
  double _ratingValue = 0.0;
  TextEditingController _reviewController = TextEditingController();

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

//fungsi untuk mendapatkan data user
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

//fungsi untuk mendaptkan data transaksi
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

//fungsi untuk update status pembayaran
  Future<void> _getStatusTransaksi() async {
    try {
      String url = 'https://adm.febriyandy.xyz/Status/${widget.id}';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var status = jsonDecode(response.body); // Parse status jika diperlukan
        setState(() {
          _statusPembayaran =
              status['status']; // Sesuaikan dengan struktur respons Anda
        });
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Error fetching status: $e');
    }
  }

  //Fungsi untuk menampilkan popup menambahkan ulasan
  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.2),
                child: AlertDialog(
                  title: Text(
                    "Tulis Ulasan",
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ratingValue = 1.0;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: _ratingValue >= 1
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ratingValue = 2.0;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: _ratingValue >= 2
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ratingValue = 3.0;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: _ratingValue >= 3
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ratingValue = 4.0;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: _ratingValue >= 4
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ratingValue = 5.0;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: _ratingValue >= 5
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Input untuk deskripsi ulasan
                        TextField(
                          controller: _reviewController,
                          decoration: InputDecoration(
                            labelText: "Ulasan",
                            labelStyle: TextStyle(
                              color: darkColor,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: darkColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: darkColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            color: darkColor,
                            fontFamily: "Poppins",
                          ),
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 40,
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
                            _submitReview();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Kirim",
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
              ),
            );
          },
        );
      },
    );
  }

//Fungsi untuk menyimpan Ulasan
  void _submitReview() {
  if (_userId != null) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Mengambil paketId dari data transaksi
      final paketId = transaksiData?['paketId'] ?? ''; 

      // Memastikan paketId valid
      if (paketId.isNotEmpty) {
        // Mengakses referensi ke node ulasan di bawah paket_wisata dengan paketId yang sesuai
        DatabaseReference ulasanRef = FirebaseDatabase.instance
            .ref()
            .child('explore-kepri/paket_wisata/$paketId/ulasan')
            .push();

        ulasanRef.set({
          'nilai_bintang': _ratingValue,
          'deskripsi_ulasan': _reviewController.text,
          'id_user': _userId,
          'displayName': user.displayName ?? 'Nama Pengguna',
          'photoURL': user.photoURL ?? 'https://example.com/avatar.jpg',
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ulasan berhasil dikirim')));
          // Optionally clear the review fields or navigate away
          _reviewController.clear();
          setState(() {
            _ratingValue = 0;
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal mengirim ulasan: $error')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal mengirim ulasan: Paket ID tidak ditemukan')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gagal mengirim ulasan: User tidak ditemukan')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Gagal mengirim ulasan: ID User tidak tersedia')));
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
                      height: 120,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 65, 0, 0),
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
                                color: blueColor,
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70, 65, 0, 0),
                            child: Text(
                              "Detail Transaksi",
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
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                  SizedBox(height: 5),
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
                                  _buildDetailRow(
                                      'Nama', transaksiData!['nama_pengguna']),
                                  _buildDetailRow(
                                      'Email', transaksiData!['email']),
                                  _buildDetailRow('Tanggal',
                                      transaksiData!['tanggal_berwisata']),
                                  _buildDetailRow('Jumlah Orang',
                                      '${transaksiData!['jumlah_orang']} Orang'),
                                  _buildDetailRow('Status Perjalanan',
                                      transaksiData!['status_perjalanan']),
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
                                  if (transaksiData!['status_perjalanan'] ==
                                      'Selesai')
                                    _buildReviewButton()
                                  else
                                    _buildContactButton(context),
                                ],
                              ),
                            ),
                          )
                        else
                          Center(child: CircularProgressIndicator()),
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

//Widget menampilkan style detail transaksi
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: darkColor,
            ),
          ),
          Text(
            value,
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
    );
  }

//widget menambilkan tombol tambah ulasan
  Widget _buildReviewButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
        _showReviewDialog();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 13.5,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkColor, primary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Tambah Ulasan",
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
    );
  }

//Widget menampilkan nomor admin penjemputan
  Widget _buildContactButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Silahkan hubungin nomor di bawah ini untuk memberikan lokasi penjemputan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            color: darkColor,
          ),
        ),
        const SizedBox(height: 15.0), // Jarak antara Text dan Container
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: "0851-6259-8308"));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied to Clipboard"),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 13.5,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [darkColor, primary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "0851-6259-8308",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
