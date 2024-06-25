import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class AuthContriller {
  final auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);

  User? get user => firebaseUser.value;


//fungsi untuk login user dengan google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

//fungsi untuk registrasi dengan firebase autentikasi
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  // fungsi untuk login dengan email dan password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  // Fungsi untuk logout
  Future<void> signout() async {
    try {
      await auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }
}

  
