import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/firebase_options.dart';
import 'package:explore_kepri/screens/home.dart';
import 'package:explore_kepri/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:explore_kepri/screens/onbording.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  // Inisialisasi Firebase sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Jalankan aplikasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);

          return GetMaterialApp(
            title: 'Explore Kepri',
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              // Tampilan splash screen dengan animasi
              splash: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxHeight * 0.6,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              duration: 3000, // Durasi splash screen (dalam milidetik)
              splashTransition: SplashTransition.fadeTransition, // Transisi animasi
              nextScreen: snapshot.data != null ? HomePage() : OnbordingView(), // Layar selanjutnya setelah splash screen
            ),
          );
        }
        return LoadingView(); // Tampilkan widget LoadingView selama proses stream belum aktif
      },
    );
  }
}
