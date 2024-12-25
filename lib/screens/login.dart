import 'dart:developer';
import 'dart:ui';

import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/landing.dart';
import 'package:explore_kepri/screens/register.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isHide = true;
  bool isLoadingPassword = false;
  bool isLoadingGoogle = false;
  final auth = AuthController();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latarbelakang.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
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
                            "Selamat Datang",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "PoppinsSemiBold",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          Text(
                            "Masukkan email dan password",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 230.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 350,
                            height: 500,
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
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Email",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: email,
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins"
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.5,
                                        horizontal: 14
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none
                                        )
                                      ),
                                      hintText: "name@gmail.com",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white.withOpacity(0.5),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: darkColor,
                                          width: 2.0
                                        )
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    child: Text(
                                      "Password",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
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
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.5,
                                        horizontal: 14
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none
                                        )
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
                                        borderSide: BorderSide(
                                          color: darkColor,
                                          width: 2.0
                                        )
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Lupa Password?",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: darkColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _login();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13.5
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [darkColor, primary],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Masuk",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0
                                      ),
                                      child: Text(
                                        "Atau",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          color: darkColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _loginGoogle();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13.5
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/google.png",
                                            width: 21,
                                            height: 21,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 14.0
                                            ),
                                            child: Text(
                                              "Masuk dengan Google",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: darkColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Belum punya akun? ",
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
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterView()
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Daftar Sekarang",
                                            style: TextStyle(
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 14,
                                              color: darkColor
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
          // Loading Overlay
          if (isLoadingPassword || isLoadingGoogle)
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

  _loginGoogle() async {
    setState(() {
      isLoadingGoogle = true;
    });
    
    try {
      final users = await auth.loginWithGoogle();
      if (users != null) {
        log("User Logged In");
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingGoogle = false;
        });
      }
    }
  }

  _login() async {
    setState(() {
      isLoadingPassword = true;
    });
    
    try {
      final user = await auth.loginUserWithEmailAndPassword(
        email.text,
        password.text
      );

      if (user != null) {
        log("User Logged In");
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingPassword = false;
        });
      }
    }
  }
}