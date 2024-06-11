import 'package:explore_kepri/screens/opening2.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    //_navigatetohome();
  }

  _navigatetohome()async{
    await Future.delayed(Duration(microseconds: 2500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context)=>MyHomePage(
        title: 'GFG',
        )));
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/Logo.png',
            width: size.width * 0.6, // Atur lebar gambar berdasarkan lebar layar
            height: size.height * 0.6, // Atur tinggi gambar berdasarkan tinggi layar
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
