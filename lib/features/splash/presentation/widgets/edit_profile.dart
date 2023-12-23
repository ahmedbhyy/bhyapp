import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLoading = true;
  final TextEditingController _nomuser = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _firme = TextEditingController();
  final TextEditingController _role = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    fetchUserData();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _nomuser.dispose();
    _profession.dispose();
    _firme.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "votre profile",
          style: TextStyle(
              fontFamily: 'Michroma',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Nom et Prénom",
              iconData: Icons.person,
              controller: _nomuser,
            ),
            const SizedBox(height: 30),
            buildTextFieldWithEditIcon(
              hintText: "Profession",
              iconData: Icons.work,
              controller: _profession,
            ),
            const SizedBox(height: 30),
            buildTextFieldWithEditIcon(
              hintText: "Firme",
              iconData: Icons.place,
              controller: _firme,
            ),
            const SizedBox(height: 30),
            buildTextFieldWithEditIcon(
              hintText: "Rôle",
              iconData: Icons.work,
              controller: _role,
              enabled: false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 8),
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  saveUserData();
                },
                child: const Text('Enregistrer'),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon({
    required String hintText,
    required TextEditingController controller,
    required IconData iconData,
    bool enabled = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              labelText: hintText,
              prefixIcon: Icon(iconData),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(_user.uid).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            (docSnapshot.data() as Map<String, dynamic>);
        _nomuser.text = userData['nom et prenom'] ?? '';
        _profession.text = userData['profession'] ?? '';
        _firme.text = userData['lieu de travail'] ?? '';
        _role.text = userData['role'] ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> saveUserData() async {
    try {
      String nomuser = _nomuser.text;
      String profession = _profession.text;
      String firme = _firme.text;

      await _firestore.collection('users').doc(_user.uid).set({
        'nom et prenom': nomuser,
        'profession': profession,
        'lieu de travail': firme,
      }, SetOptions(merge: true));
      setState(() {});

      final firsttime = FirebaseAuth.instance.currentUser!.displayName == null;
      if (nomuser.isNotEmpty &&
          profession.isNotEmpty &&
          firme.isNotEmpty &&
          firsttime) {
        FirebaseAuth.instance.currentUser!.updateDisplayName("done");
        _firestore
            .collection('users')
            .doc(_user.uid)
            .set({"role": "user"}, SetOptions(merge: true));
        Navigator.pop(context, true);
      }

      print('User data saved to Firestore');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
