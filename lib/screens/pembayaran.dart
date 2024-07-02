import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String midtransClientKey = 'SB-Mid-client-QvVfCv3niY8bhqBZ'; 
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Aktifkan WebView pada initState
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: FutureBuilder<String>(
          future: _fetchToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              return WebView(
                initialUrl: snapshot.data!,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
              );
            } else {
              return Center(child: Text('Failed to load payment page'));
            }
          },
        ),
      ),
    );
  }

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

      var url = Uri.parse('http://192.168.217.116:7600/Transaksi/${widget.id}');
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
