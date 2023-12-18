import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nomuser = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _firme = TextEditingController();
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
          "Edit Profil",
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
              controller: _nomuser,
            ),
            const SizedBox(height: 30),
            buildTextFieldWithEditIcon(
              hintText: "Profession",
              controller: _profession,
            ),
            const SizedBox(height: 30),
            buildTextFieldWithEditIcon(
              hintText: "Firme",
              controller: _firme,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 8),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon(
      {required String hintText, required TextEditingController controller}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              labelText: hintText,
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
}
