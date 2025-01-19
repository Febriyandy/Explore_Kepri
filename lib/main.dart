import 'package:explore_kepri/firebase_options.dart';
import 'package:explore_kepri/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 
  runApp(MyApp());
}

//Halaman utama untuk menjalankan aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
          return GetMaterialApp(
            title: 'Explore Kepri',
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
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
              duration: 3000,
              splashTransition: SplashTransition.fadeTransition, 
              nextScreen: const  Wrapper(), 
            ),
          );
        }
        
}
