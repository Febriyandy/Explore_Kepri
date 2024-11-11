import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/onbording.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthController auth = AuthController();
  User? user = FirebaseAuth.instance.currentUser;

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
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/images/profil.png') as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.displayName ?? 'Guest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user?.email ?? 'Email not available',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        
                      },
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [darkColor, primary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Edit Profile",
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
                    const SizedBox(height: 20),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                              'Pengaturan Akun',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkColor,
                                
                              ),
                                              ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/keamanan.svg',
                            color: darkColor,
                            width: 24,
                            height: 24,
                          ),
                          title: Text(
                            'Keamanan Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman keamanan akun
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/syarat.svg',
                            color: darkColor,
                            width: 24,
                            height: 24,
                          ),
                          title: Text(
                            'Syarat dan Ketentuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman pengaturan
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/privasi.svg',
                            color: darkColor,
                            width: 25,
                            height: 25,
                          ),
                          title: Text(
                            'Kebijakan Privasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman pengaturan
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/kontak.svg',
                            color: darkColor,
                            width: 24,
                            height: 24,
                          ),
                          title: Text(
                            'Kontak Kami',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman pengaturan
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/keluar.svg',
                            color: darkColor,
                            width: 25,
                            height: 25,
                          ),
                          title: Text(
                            'Keluar Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          onTap: () async {
                            await auth.signOut();
                            goToLogin(context);
                          },
                        ),
                      ],
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