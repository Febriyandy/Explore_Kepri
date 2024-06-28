import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/onbording.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final auth = AuthContriller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/latarbelakang.png'),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height, // Menggunakan tinggi layar penuh
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 150,
                    height: 100,
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Profil Page',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        await auth.signout();
                        goToLogin(context);
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(vertical: 13.5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
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
            ],
          ),
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OnbordingView()),
    );
  }
}
