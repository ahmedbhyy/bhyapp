import 'dart:io';
import 'package:bhyapp/features/splash/presentation/widgets/splash_body.dart';
import 'package:flutter/material.dart';

import 'package:bhyapp/features/splash/presentation/widgets/about_us.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/edit_profile.dart';
import 'package:bhyapp/features/splash/presentation/widgets/weather.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PickedFile _imageFile = PickedFile("");
  final ImagePicker _picker = ImagePicker();
  String? username;
  String? extractedUsername;
  @override
  void initState() {
    username = FirebaseAuth.instance.currentUser?.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (username != null) {
      int atIndex = username!.indexOf('@');
      extractedUsername =
          atIndex != -1 ? username!.substring(0, atIndex) : null;
    }
    return Stack(
      children: [
        Image.asset(
          'images/background2.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 365),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SplashBody()),
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                  ),
                ),
                imageProfile(),
                const SizedBox(height: 30),
                Text(
                  extractedUsername as String,
                  style: const TextStyle(
                    fontFamily: 'Michroma',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5f0f40),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUs(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x0042D351),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF191919)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: 320,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Qui sommes-nous',
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 18,
                            fontFamily: 'Michroma',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 4.08,
                          ),
                        ),
                        SizedBox(width: 28),
                        Icon(
                          Icons.panorama_photosphere,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x0042D351),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF191919)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: 320,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Modifiez votre profil',
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontFamily: 'Michroma',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 4.08,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.settings,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile.path.isNotEmpty
              ? FileImage(File(_imageFile.path))
              : null,
          backgroundColor: Colors.grey,
          child: _imageFile.path.isNotEmpty
              ? null
              : const Icon(
                  Icons.person,
                  color: Colors.teal,
                  size: 105.0,
                ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = PickedFile(pickedFile.path);
      }
    });
  }
}
