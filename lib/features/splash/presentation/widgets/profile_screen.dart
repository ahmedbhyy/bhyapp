import 'dart:io';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/splash_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bhyapp/features/splash/presentation/widgets/about_us.dart';
import 'package:bhyapp/features/splash/presentation/widgets/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserLocal? user;
  String _imageFile = '';
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;
    db.collection("users").doc(newprofilpic).get().then((value) {
      setState(() {
        user = UserLocal(
          role: value.data()!["role"],
          firm: value.data()!["lieu de travail"],
          name: value.data()!["nom et prenom"],
          uid: newprofilpic,
        );
      });
    });
    final store = FirebaseStorage.instance.ref();
    final pdpref = store.child("profil/$newprofilpic.jpg");
    try {
      pdpref.getDownloadURL().then((value) {
        setState(() {
          _imageFile = value;
        });
      }, onError: (val) {});
    } catch (e) {
      if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("une erreur est survenue veuillez réessayer ultérieurement")));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/background2.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Column(
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SplashBody()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: Platform.isAndroid ? 24 : 50,
                ),
              ),
            ),
            imageProfile(),
            const SizedBox(height: 30),
            Text(
              user != null ? user!.name : "",
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
                  side: const BorderSide(width: 1, color: Color(0xFF191919)),
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
                    builder: (context) => const ProfileSettings(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x0042D351),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF191919)),
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
            Visibility(
              visible: Platform.isAndroid,
              child: TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  takePhoto2(ImageSource.camera);
                },
                label: const Text("Camera"),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto2(ImageSource.gallery);
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
          backgroundImage:
              _imageFile.isNotEmpty ? NetworkImage(_imageFile) : null,
          backgroundColor: Colors.grey,
          child: _imageFile.isNotEmpty
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
        _imageFile = pickedFile.path;
        Navigator.pop(context);
      }
    });
  }

  Future<void> takePhoto2(ImageSource source) async {
    final newprofilpic = FirebaseAuth.instance.currentUser!.uid;
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 20,
    );
    if (((pickedFile?.path) ?? '').isNotEmpty) {
      String path = pickedFile!.path;
      File file = File(path);
      final store = FirebaseStorage.instance.ref();
      final pdpref = store.child("profil/$newprofilpic.jpg");
      await pdpref.putFile(file);
      path = await pdpref.getDownloadURL();
      setState(() {
        _imageFile = path;
        Navigator.pop(context);
      });
      return;
    }
  }
}
