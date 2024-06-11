import 'package:explore_kepri/screens/onbording.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Kepri',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen( //membuat tampilan spalsh screen
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
        nextScreen: const OnbordingView(),
      ),
    );
  }
}

