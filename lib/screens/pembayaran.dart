import 'dart:async';
import 'dart:convert';
import 'package:explore_kepri/screens/transaksi.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PembayaranPage extends StatefulWidget {
  final String id;
  final Map<dynamic, dynamic>? paketData;
  final String date;
  final int jumlahOrang;
  final int totalPembayaran;

  const PembayaranPage({
    Key? key,
    required this.id,
    required this.paketData,
    required this.date,
    required this.jumlahOrang,
    required this.totalPembayaran,
  }) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Page resource error: $error');
          },
        ),
      );
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
                              "Pembayaran",
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FutureBuilder<String>(
                      future: _fetchToken(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data != null) {
                          _controller.loadRequest(Uri.parse(snapshot.data!));
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 140,
                            child: WebViewWidget(controller: _controller),
                          );
                        } else {
                          return Center(
                              child: Text('Failed to load payment page'));
                        }
                      },
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

//Fungsi untuk mengirim data transaksi ke backend untuk proses pembayaran dan menerima token untuk melakukan pembayaran
  Future<String> _fetchToken() async {
    try {
      var data = {
        'nama_pengguna': FirebaseAuth.instance.currentUser!.displayName!,
        'email': FirebaseAuth.instance.currentUser!.email!,
        'nama_paket': widget.paketData!['nama_paket'],
        'photoUrlPaket': widget.paketData!['images'][0],
        'tanggal_berwisata': widget.date,
        'jumlah_orang': widget.jumlahOrang.toString(),
        'no_wa': widget.jumlahOrang.toString(),
        'gross_amount': widget.totalPembayaran.toString(),
        'hargaPerOrang': widget.totalPembayaran.toString(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      };

      var url = Uri.parse('https://api-explore-kepri.febriandi.my.id/Transaksi/${widget.id}');
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var redirectUrl = responseData['token']['redirect_url'];

        if (redirectUrl != null) {
          return redirectUrl;
        } else {
          throw Exception('Redirect URL not found in response');
        }
      } else {
        throw Exception('Failed to save transaction: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending transaction data: $error');
      throw Exception('Error sending transaction data: $error');
    }
  }
}
