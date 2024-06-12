import 'package:explore_kepri/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:explore_kepri/utils/theme.dart';

List onbordingData = [
  {
    "title":"Selamat Datang di\nExplore Kepri",
    "image":"assets/images/onbording1.png",
    "deskripsi":"Temukan pesona Kepulauan Riau yang memukau, dari pantai berpasir putih hingga budaya lokal yang kaya. Mulailah petualangan Anda di sini dan nikmati pengalaman yang tak terlupakan",
  },
  {
    "title":"Jelajahi Destinasi\nMenakjubkan",
    "image":"assets/images/onbording2.png",
    "deskripsi":"Dengan Explore Kepri, Anda bisa menjelajahi berbagai destinasi menakjubkan. Dapatkan informasi lengkap tentang tempat-tempat wisata dan paket wisata",
  },
  {
    "title":"Paket Wisata Spesial\n dan Esklusif",
    "image":"assets/images/onbording3.png",
    "deskripsi":"Nikmati kemudahan merencanakan liburan Anda dengan paket wisata spesial dari Explore Kepri. Kami menawarkan paket petualangan hingga liburan santai",
  },
  
];


class OnbordingView extends StatefulWidget {
  const OnbordingView({super.key});

  @override
  State<OnbordingView> createState() => _OnbordingViewState();
}

class _OnbordingViewState extends State<OnbordingView> {
  final PageController pageController = PageController();
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mengganti warna Background
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (v){
                    print(v.toString());
                    setState(() {
                      currentpage = v;
                    });
                  },
                  itemCount: onbordingData.length,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 100.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              onbordingData[i]['title'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "PoppinsSemiBold",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            onbordingData[i]['image'],
                            width: constraints.maxWidth * 0.6,
                            height: constraints.maxHeight * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                          child: Column(
                            children: [
                              Text(
                                onbordingData[i]['deskripsi'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: darkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24), // Menambahkan jarak di bawah PageView
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Wrap(
                      spacing: 6,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                              color: currentpage == 0 ? darkColor : grayColor,
                              borderRadius: BorderRadius.circular(1000),
                            ),
                          height: 8,
                          width: currentpage == 0 ? 20 : 8,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                              color: currentpage == 1 ? darkColor : grayColor,
                              borderRadius: BorderRadius.circular(1000),
                            ),
                          height: 8,
                          width: currentpage == 1 ? 20 : 8,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                              color: currentpage == 2 ? darkColor : grayColor,
                              borderRadius: BorderRadius.circular(1000),
                            ),
                          height: 8,
                          width: currentpage == 2 ? 20 : 8,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: GestureDetector(
                      onTap: () {
                        if (currentpage == 2 ) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const LoginView()));
                        } else {
                          pageController.animateToPage(currentpage+1, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut );
                        }
                        print("Ketuk Untuk Selanjutnya");
                      },
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
                        child: Text(
                          currentpage == 2 ? "Mulai Sekarang" : "Ketuk Untuk Selanjutnya",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50), // Menambahkan jarak antara button dan bagian bawah layar
            ],
          );
        },
      ),
    );
  }
}
