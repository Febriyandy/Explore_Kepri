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
  String? _userId; // Untuk menyimpan id user yang sedang login

  @override
  void initState() {
    super.initState();
    _fetchDestinasiData();
    _fetchUlasanData(); // Panggil method untuk mengambil data ulasan
    _getCurrentUser(); // Panggil method untuk mendapatkan id user yang sedang login
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  Future<void> _fetchDestinasiData() async {
    DatabaseEvent event = await _databaseReference.child(widget.id).once();
    var data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      setState(() {
        destinasiData = data;
      });
    }
  }

  Future<void> _fetchUlasanData() async {
    DatabaseEvent event =
        await _databaseReference.child('${widget.id}/ulasan').once();
    var data = event.snapshot.value;

    if (data != null && data is Map) {
      // Convert Map to List<dynamic>
      List<dynamic> dataList = data.values.toList();

      setState(() {
        ulasanData = dataList;
      });
    }
  }

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
                  content: Container(
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
                              borderSide: BorderSide(
                                  color:
                                      darkColor), // Ubah warna border outline
                              borderRadius: BorderRadius.circular(
                                  10), // Ubah radius border outline
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      darkColor), // Ubah warna border saat fokus
                              borderRadius: BorderRadius.circular(
                                  10), // Ubah radius border saat fokus
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: darkColor.withOpacity(
                                      0.5)), // Ubah warna border saat tidak fokus
                              borderRadius: BorderRadius.circular(
                                  10), // Ubah radius border saat tidak fokus
                            ),
                          ),
                          style: TextStyle(
                            color: darkColor, // Ubah warna teks
                            fontFamily: "Poppins", // Ubah jenis font teks
                          ),
                          maxLines: 6, // Ubah jumlah maksimal baris
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

 void _submitReview() {
  // Pastikan ada id user yang sedang login
  if (_userId != null) {
    // Ambil informasi user yang sedang login
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Simpan ulasan ke Firebase Realtime Database
      DatabaseReference ulasanRef =
          _databaseReference.child('${widget.id}/ulasan').push();
      ulasanRef.set({
        'nilai_bintang': _ratingValue,
        'deskripsi_ulasan': _reviewController.text,
        'id_user': _userId, // Gunakan id user yang sedang login
        'displayName': user.displayName ?? 'Nama Pengguna',
        'photoURL': user.photoURL ?? 'https://example.com/avatar.jpg',
      }).then((_) {
        // Berhasil menyimpan
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ulasan berhasil dikirim')));
        // Refresh data ulasan setelah mengirim ulasan baru
        _fetchUlasanData();
      }).catchError((error) {
        // Error ketika menyimpan
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim ulasan: $error')));
      });
    } else {
      // Handle jika user tidak ditemukan (seharusnya tidak terjadi)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim ulasan: User tidak ditemukan')));
    }
  } else {
    // Handle jika id user tidak tersedia (seharusnya tidak terjadi)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengirim ulasan: ID User tidak tersedia')));
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
                                          const DestinasiPage()));
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
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  destinasiData!['nama_tempat'],
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
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/lokasi.svg',
                                    color: blueColor,
                                    width: 15.0,
                                    height: 15.0,
                                  ),
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
                                      center: LatLng(
                                        double.parse(
                                            destinasiData!['letitude']),
                                        double.parse(
                                            destinasiData!['longitude']),
                                      ),
                                      zoom: 11,
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
                            SizedBox(height: 5),
                            ulasanData == null
                                ? SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ulasan['displayName'] ?? 'Nama Pengguna',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 5),
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
              style: TextStyle(
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
