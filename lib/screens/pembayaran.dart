import 'dart:async';
import 'dart:convert';
import 'package:explore_kepri/screens/datailPesanan.dart';
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
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true; // Set loading state true when page starts loading
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false; // Set loading state false when page finishes loading
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('finish')) {
              // Assuming 'finish' is a keyword in the URL that indicates the payment is complete
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => TransaksiPage(),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    _loadUrl(); // Load URL when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => DetailPesananPage(id: widget.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/icons/back.svg',
              color: darkColor,
              width: 30.0,
              height: 30.0,
            ),
          ),
        ),
        title: Text(
          'Detail Pemesanan',
          style: TextStyle(
            color: darkColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        backgroundColor: Colors.white, // Set the background color of the AppBar to white
        elevation: 0, // Remove shadow
      ),
      backgroundColor: Colors.white, // Set the background color of the Scaffold to white
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator
            ),
        ],
      ),
    );
  }

  Future<void> _loadUrl() async {
  try {
    final String? redirectUrl = await _fetchToken();
    if (redirectUrl != null) {
      _controller.loadRequest(Uri.parse(redirectUrl));
    } else {
      // Handle the case where redirectUrl is null
      print('Failed to fetch the redirect URL');
      // You can show an error message to the user here
    }
  } catch (e) {
    // Handle any exceptions that occur during the fetch
    print('An error occurred: $e');
    // You can show an error message to the user here
  }
}

Future<String?> _fetchToken() async {
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
      'hargaPerOrang': (widget.totalPembayaran / widget.jumlahOrang).toString(),
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