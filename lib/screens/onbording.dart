import 'package:flutter/material.dart';
import 'package:explore_kepri/utils/theme.dart';

class OnbordingView extends StatefulWidget {
  const OnbordingView({super.key});

  @override
  State<OnbordingView> createState() => _OnbordingViewState();
}

class _OnbordingViewState extends State<OnbordingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 100.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selamat Datang di\nExplore Kepri',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "PoppinsSemiBold",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Align(
                alignment: Alignment.topCenter, // Menggeser foto ke atas
                child: Image.asset(
                  'assets/images/onbording1.png',
                  width: constraints.maxWidth * 0.6,
                  height: constraints.maxHeight * 0.3, // Sesuaikan tinggi sesuai kebutuhan
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24), // Menambahkan jarak antara foto dan teks
              Padding(
                padding: const EdgeInsets.fromLTRB(44, 10, 44, 0),
                child: Column(
                  children: [
                    Text(
                      "Temukan pesona Kepulauan Riau yang memukau, dari pantai berpasir putih hingga budaya lokal yang kaya. Mulailah petualangan Anda di sini dan nikmati pengalaman yang tak terlupakan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: darkColor,
                    ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: GestureDetector(
                  onTap: () {
                    print("Ketuk Untuk Selanjutnya");
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: [darkColor, primary], // Warna gradien dari darkColor ke primary
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      ), 
                      borderRadius: BorderRadius.circular(10)
                      ),
                    child: const Text("Ketuk Untuk Selanjutnya",
                    textAlign: TextAlign.center, 
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14, color: Colors.white),
                    ) ,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
