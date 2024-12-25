import 'dart:developer';
import 'dart:ui';
import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/screens/login.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isHide = true;
  bool isLoading = false;
  final auth = AuthController();

  final nama = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nama.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 140.0, left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daftar Akun",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "PoppinsSemiBold",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          Text(
                            "Mohon isi data berikut dengan benar",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: darkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 260,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 350,
                            height: 450,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTextField("Nama Lengkap", "Masukkan Nama Lengkap", nama),
                                  const SizedBox(height: 20),
                                  buildTextField("Email", "name@gmail.com", email),
                                  const SizedBox(height: 20),
                                  buildPasswordField(),
                                  const SizedBox(height: 30),
                                  buildRegisterButton(),
                                  buildLoginLink(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CircularProgressIndicator(
                    color: darkColor,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: darkColor,
            fontSize: 14,
            fontFamily: "Poppins"
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: grayColor,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: darkColor, width: 2.0)
            )
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: password,
          obscureText: isHide,
          style: TextStyle(
            color: darkColor,
            fontSize: 14,
            fontFamily: "Poppins"
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isHide = !isHide;
                });
              },
              icon: Icon(
                isHide ? Icons.visibility : Icons.visibility_off,
                color: grayColor,
                size: 18,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)
            ),
            hintText: "Masukkan Password",
            hintStyle: TextStyle(
              color: grayColor,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: darkColor, width: 2.0)
            )
          ),
        ),
      ],
    );
  }

  Widget buildRegisterButton() {
    return GestureDetector(
      onTap: _signup,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkColor, primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "Daftar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sudah punya akun? ",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: darkColor
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            child: Text(
              "Masuk Sekarang",
              style: TextStyle(
                fontFamily: "PoppinsSemiBold",
                fontSize: 14,
                color: darkColor
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  Future<void> _signup() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await auth.createUserWithEmailAndPassword(email.text, password.text);
      if (user != null) {
        log("User Created Successfully");
        await user.updateProfile(displayName: nama.text);
        log("Display Name Updated Successfully");
        await _saveUserData(user);
        goToHome(context);
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveUserData(User user) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('explore-kepri')
          .child('users');

      await user.reload();
      user = FirebaseAuth.instance.currentUser!;

      await userRef.child(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}