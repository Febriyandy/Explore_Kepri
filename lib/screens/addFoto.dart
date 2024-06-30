import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:explore_kepri/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddFotoPage extends StatefulWidget {
  const AddFotoPage({Key? key}) : super(key: key);

  @override
  State<AddFotoPage> createState() => _AddFotoPageState();
}

class _AddFotoPageState extends State<AddFotoPage> {
  String? selectedLocation;
  File? selectedImage;
  final TextEditingController captionController = TextEditingController();
  final List<String> locations = [
    'Kabupaten Bintan',
    'Kabupaten Karimun',
    'Kota Tanjungpinang',
    'Kota Batam',
    'Kabupaten Natuna',
    'Kabupaten Anambas',
    'Kabupaten Lingga'
  ];

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  Future<void> _uploadImage() async {
    if (selectedImage == null || selectedLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('galeri/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageRef.putFile(selectedImage!);

      // Update UI for progress indicator
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      // Await until upload completes
      await uploadTask;

      final imageUrl = await storageRef.getDownloadURL();

      final databaseRef =
          FirebaseDatabase.instance.ref('explore-kepri/galeri').push();
      await databaseRef.set({
        'urlPhoto': imageUrl,
        'kabupaten': selectedLocation,
        'caption': captionController.text,
        'displayName': user.displayName ?? 'Anonymous',
        'userPhotoUrl': user.photoURL ?? '',
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
          selectedImage = null;
          selectedLocation = null;
          captionController.clear();
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Foto berhasil dikirim'),
            backgroundColor: blueColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error uploading image: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim foto. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 400,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          child: selectedImage != null
                              ? Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: _removeImage,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: darkColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/camera.svg',
                                      height: 100,
                                      color: blueColor,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Tambahkan Foto Terbaikmu Disini",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: blueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 20.0),
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          width: 140,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [darkColor, primary],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Pilih Foto",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: Colors.white,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lokasi Wisata",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      items: locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(
                            location,
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 14,
                              fontFamily: "Poppins",
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        hintText: "Pilih Lokasi Wisata",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "Poppins",
                        ),
                        fillColor: Colors.white.withOpacity(0.5),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: darkColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Caption",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: captionController,
                      style: TextStyle(
                          color: darkColor,
                          fontSize: 14,
                          fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        hintText: "Masukkan Caption",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: "Poppins",
                        ),
                        fillColor: Colors.white.withOpacity(0.5),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: darkColor, width: 2.0),
                        ),
                      ),
                      maxLines: 6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(darkColor),
                        ))
                        : Container(
                            width: 140,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [darkColor, primary],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: _uploadImage,
                                child: const Text(
                                  "Kirim",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.white,
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
        ],
      ),
    );
  }
}
