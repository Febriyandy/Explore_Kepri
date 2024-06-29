import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);

  User? get user => firebaseUser.value;

  // fungsi untuk login user dengan Google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(cred);
      await _saveUserData(userCredential.user!);  // Save user data to Realtime Database
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // fungsi untuk registrasi dengan Firebase Authentication dan menyimpan data ke Realtime Database
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data pengguna ke Realtime Database
      await _saveUserData(cred.user!);

      return cred.user;
    } catch (e) {
      print('Error creating user: $e');
    }
    return null;
  }

  // fungsi untuk login dengan email dan password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print('Error logging in: $e');
    }
    return null;
  }

  // Fungsi untuk logout
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Fungsi untuk menyimpan data pengguna ke Realtime Database
  Future<void> _saveUserData(User user) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('explore-kepri').child('users');

      // Ambil data pengguna dari Firebase Auth untuk memastikan displayName dan photoURL yang terbaru
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;

      // Simpan data pengguna ke Realtime Database
      await userRef.child(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        // tambahkan data pengguna lain yang ingin Anda simpan
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
