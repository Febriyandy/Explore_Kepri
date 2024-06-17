import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class AuthContriller {
  final auth = FirebaseAuth.instance;

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

  // Stream untuk memantau status autentikasi pengguna
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

  void register(String nama, String email, String password) async {
    try {
      UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(nama);
        print('User registered successfully: ${user.uid}');
      } else {
        print('Gagal mendapatkan user setelah registrasi.');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password yang diberikan terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        print('Akun sudah ada untuk email tersebut.');
      } else {
        print('Terjadi kesalahan saat mencoba untuk mendaftar: ${e.message}');
      }
    } catch (e) {
      print('Terjadi kesalahan yang tidak diketahui: $e');
    }
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
