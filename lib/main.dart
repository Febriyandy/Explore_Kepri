import 'package:explore_kepri/firebase_options.dart';
import 'package:explore_kepri/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
              nextScreen: const  Wrapper(), // Layar selanjutnya setelah splash screen
            ),
          );
        }
        
}
