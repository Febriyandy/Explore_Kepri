import 'package:flutter/material.dart';
import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './home.dart';
import './transaksi.dart';
import './addFoto.dart';
import './profil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _bottomNavCurrentIndex = 0;
  List<Widget> _container = [
    HomePage(),
    TransaksiPage(),
    AddFotoPage(),
    ProfilPage(),
  ];

//widget untuk membuat button navigatin bar menu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          IndexedStack(
            index: _bottomNavCurrentIndex,
            children: _container,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() {
                    _bottomNavCurrentIndex = index;
                  });
                },
                currentIndex: _bottomNavCurrentIndex,
                selectedItemColor: blueColor,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(fontSize: 12.0 , fontFamily: "Poppins"), 
                unselectedLabelStyle: const TextStyle(fontSize: 12.0 , fontFamily: "Poppins"),
                items: [
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: blueColor,
                      width: 25.0,
                      height: 25.0,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: Colors.grey,
                      width: 25.0,
                      height: 25.0,
                    ),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/transaksi.svg',
                      color: blueColor,
                      width: 25.0,
                      height: 25.0,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/transaksi.svg',
                      color: Colors.grey,
                      width: 25.0,
                      height: 25.0,
                    ),
                    label: 'Transaksi',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/foto.svg',
                      color: blueColor,
                      width: 25.0,
                      height: 25.0,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/foto.svg',
                      color: Colors.grey,
                      width: 25.0,
                      height: 25.0,
                    ),
                    label: 'Tambah Foto',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/profil.svg',
                      color: blueColor,
                      width: 25.0,
                      height: 25.0,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/profil.svg',
                      color: Colors.grey,
                      width: 25.0,
                      height: 25.0,
                    ),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
