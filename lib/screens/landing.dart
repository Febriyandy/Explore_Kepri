import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.attach_money,
              color: Colors.red,
            ),
            icon: Icon(
              Icons.attach_money,
              color: Colors.grey,
            ),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.add_a_photo,
              color: Colors.red,
            ),
            icon: Icon(
              Icons.add_a_photo,
              color: Colors.grey,
            ),
            label: 'Tambah Foto',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
              color: Colors.red,
            ),
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
