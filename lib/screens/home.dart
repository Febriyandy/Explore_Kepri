import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello World',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), // Menambahkan jarak antara teks dan tombol
            GestureDetector(
              onTap: () {
                authC.logout();
              },
              child: Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 13.5),
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [darkColor, primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Keluar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

