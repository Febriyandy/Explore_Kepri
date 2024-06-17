import 'package:explore_kepri/controllers/auth_contriller.dart';
import 'package:explore_kepri/screens/login.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:get/get.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isHide = true;
  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
 
 final authC = Get.find<AuthController>();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latarbelakang.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context)
                .size
                .height, // Menggunakan tinggi layar penuh
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Nama Lengkap",
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
                                  controller: namaC,
                                  style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins"),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      hintText: "Masukkan Nama Lengkap",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white.withOpacity(0.5),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                                  controller: emailC,
                                  style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins"),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      hintText: "name@gmail.com",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white.withOpacity(0.5),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0))),
                                ),
                                // Add some space
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                                  controller: passwordC,
                                  obscureText: isHide,
                                  style: TextStyle(
                                      color: darkColor,
                                      fontSize: 14,
                                      fontFamily: "Poppins"),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isHide = !isHide;
                                          });
                                        },
                                        icon: Icon(
                                          isHide
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: grayColor,
                                          size: 18,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12.5, horizontal: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      hintText: "Masukkan Password",
                                      hintStyle: TextStyle(
                                        color: grayColor,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                      fillColor: Colors.white.withOpacity(0.5),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0))),
                                ),
                                 
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: (){
                                    authC.register(namaC.text, emailC.text, passwordC.text);
                                  }, 
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13.5),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sudah punya akun? ",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: darkColor),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                  const  LoginView()),
                                          );
                                        },
                                        child: Text(
                                          "Masuk Sekarang",
                                          style: TextStyle(
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 14,
                                              color: darkColor),
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
        ));
  }
}
