import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:explore_kepri/screens/destinasi.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';

class DetailDestinasiPage extends StatefulWidget {
  final String id;
  const DetailDestinasiPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailDestinasiPage> createState() => _DetailDestinasiPageState();
}

class _DetailDestinasiPageState extends State<DetailDestinasiPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('explore-kepri/destinasi');
  Map<dynamic, dynamic>? destinasiData;
  List<dynamic>? ulasanData;
  TextEditingController _reviewController = TextEditingController();
  double _ratingValue = 0.0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchDestinasiData();
    _fetchUlasanData();
    _getCurrentUser();
  }

//Fungsi untuk mendapatkan Id user
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  //Fungsi untuk mendapatkan data Destinasi Berdasarkan Id
  Future<void> _fetchDestinasiData() async {
    DatabaseEvent event = await _databaseReference.child(widget.id).once();
    var data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      setState(() {
        destinasiData = data;
      });
    }
  }

//Fungsi untuk menghitung rating Destinasi berdasarkan nilai Ulasan Pengguna
  void _hitungRating() {
    if (ulasanData != null && ulasanData!.isNotEmpty) {
      double totalRating = 0.0;
      for (var ulasan in ulasanData!) {
        totalRating += ulasan['nilai_bintang'];
      }
      double averageRating = totalRating / ulasanData!.length;
      DatabaseReference destinasiRef = FirebaseDatabase.instance
          .ref()
          .child('explore-kepri/destinasi/${widget.id}');
      destinasiRef.update({'rating': averageRating}).then((_) {
        print('Rating berhasil diupdate: $averageRating');
        _fetchDestinasiData();
      }).catchError((error) {
        print('Gagal mengupdate rating: $error');
      });
    } else {
      print('Tidak ada ulasan yang tersedia.');
    }
  }

//Fungsi untuk mendapatkan data ulasan
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
        DatabaseReference ulasanRef =
            _databaseReference.child('${widget.id}/ulasan').push();
        ulasanRef.set({
          'nilai_bintang': _ratingValue,
          'deskripsi_ulasan': _reviewController.text,
          'id_user': _userId,
          'displayName': user.displayName ?? 'Nama Pengguna',
          'photoURL': user.photoURL ?? 'https://example.com/avatar.jpg',
        }).then((_) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Ulasan berhasil dikirim')));
          _fetchUlasanData();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal mengirim ulasan: $error')));
        });
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
    return Scaffold(
      body: Stack(
        children: [
//Container backround utama
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

//Container tulisan Destinasi wisata dan icon Back
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
                                          const DestinasiPage()));
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

//Container menampilkan foto destinasi dari database
              destinasiData == null
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 25.0),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 220.0,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                                items:
                                    (destinasiData!['images'] as List<dynamic>)
                                        .map((item) => ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.network(
                                                item,
                                                fit: BoxFit.cover,
                                                width: 1000,
                                              ),
                                            ))
                                        .toList(),
                              ),
                            ),

//Container menampilakan nama destinasi, kabupaten dan rating
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
                                          destinasiData!['nama_tempat'],
                                          style: TextStyle(
                                            color: darkColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/lokasi.svg',
                                              color: blueColor,
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              destinasiData!['kabupaten'],
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
                                        destinasiData != null &&
                                                destinasiData!['rating'] != null
                                            ? destinasiData!['rating']
                                                .toStringAsFixed(1)
                                            : '-',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(',
                                        style: TextStyle(
                                          fontSize: 16,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        ')',
                                        style: TextStyle(
                                          fontSize: 16,
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

//Container menampilkan deskripsi dari database
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
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
                                        child: Text(
                                          destinasiData!['deskripsi'],
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

//Container menampilkan text alamat dan data alamat dari database
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
                                  horizontal: 25.0, vertical: 10.0),
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
                                        child: Text(
                                          destinasiData!['alamat'],
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

//Container menampilkan text lokasi
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Lokasi",
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ),

//Container menampilkan peta berdasarkan latitude dan longitude dari database
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1),
                                  ),
                                ),
                                width: 400,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: FlutterMap(
                                    options: MapOptions(
                                      // ignore: deprecated_member_use
                                      center: LatLng(
                                        double.parse(
                                            destinasiData!['letitude']),
                                        double.parse(
                                            destinasiData!['longitude']),
                                      ),
                                      // ignore: deprecated_member_use
                                      zoom: 11,
                                      // ignore: deprecated_member_use
                                      interactiveFlags: InteractiveFlag.all &
                                          ~InteractiveFlag.doubleTapZoom,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName:
                                            'dev.fleaflet.flutter_map.example',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: LatLng(
                                              double.parse(
                                                  destinasiData!['letitude']),
                                              double.parse(
                                                  destinasiData!['longitude']),
                                            ),
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.centerLeft,
                                            child: const Icon(
                                              Icons.location_pin,
                                              size: 40,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

//Container menampilkan text ulasan dan tombol tulis ulasan
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 20, 25, 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ulasan",
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
                                  padding: const EdgeInsets.only(right: 25.0),
                                  child: Container(
                                    width: 130,
                                    height: 35,
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
                                          _showReviewDialog(); // Call _showReviewDialog() here
                                        },
                                        child: const Text(
                                          "Tulis Ulasan",
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
                                ),
                              ],
                            ),

//Container menampilkan data ulasan yang terdapat di database
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
                                      height:
                                          200, // Sesuaikan dengan tinggi yang diinginkan
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


