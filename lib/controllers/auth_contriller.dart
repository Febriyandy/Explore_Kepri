import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Stream untuk memantau status autentikasi pengguna
  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  // Fungsi untuk login
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Tidak ada pengguna yang ditemukan dengan email tersebut.');
      } else if (e.code == 'wrong-password') {
        print('Kata sandi yang diberikan salah.');
      }
    }
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
  void logout() async {
    await auth.signOut();
  }
}
