import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';

class AddFotoPage extends StatefulWidget {
  const AddFotoPage({super.key});

  @override
  State<AddFotoPage> createState() => _AddFotoPageState();
}

class _AddFotoPageState extends State<AddFotoPage> {

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
          height: MediaQuery.of(context).size.height, // Menggunakan tinggi layar penuh
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
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tambah Foto Page')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
