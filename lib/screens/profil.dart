import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/onbording.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthController auth = AuthController();
  User? user = FirebaseAuth.instance.currentUser;

//widget untuk menampilkan halaman profil dan melakukan logout dari aplikasi
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
          height: MediaQuery.of(context).size.height,
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
                top: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (user?.photoURL != null)
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      )
                    else
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profil.png'),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      user?.displayName ?? 'Guest',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.email ?? 'Email not available',
                      style: TextStyle(
                        fontSize: 16,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        await auth.signOut();
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnbordingView()),
    );
  }
}
