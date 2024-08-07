import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/screens/onbording.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

//fungsi untuk menentukan halaman jika user apakah sudah login atau belum
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),
          );
        }else if (snapshot.hasError){
          return const Center(child:  Text("Error"),
          );
        } else {
          if(snapshot.data == null) {
            return const OnbordingView();
          }else{
            return const LandingPage();
          }
        }
      }
      ),
    );
  }
}