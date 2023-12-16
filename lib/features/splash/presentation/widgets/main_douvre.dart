import 'package:flutter/material.dart';

class Maindoeuvre extends StatefulWidget {
  const Maindoeuvre({super.key});

  @override
  State<Maindoeuvre> createState() => _MaindoeuvreState();
}

class _MaindoeuvreState extends State<Maindoeuvre> {
  final TextEditingController _nombrehomme = TextEditingController();
  final TextEditingController _chargehomme = TextEditingController();
  final TextEditingController _nombrefemme = TextEditingController();
  final TextEditingController _chargefemme = TextEditingController();
  final TextEditingController _nombrehomme2 = TextEditingController();
  final TextEditingController _chargehomme2 = TextEditingController();
  final TextEditingController _nombrefemme2 = TextEditingController();
  final TextEditingController _chargefemme2 = TextEditingController();
  @override
  void dispose() {
    _nombrehomme.dispose();
    _chargehomme.dispose();
    _nombrefemme.dispose();
    _chargefemme.dispose();
    _nombrehomme2.dispose();
    _chargehomme2.dispose();
    _nombrefemme2.dispose();
    _chargefemme2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Main D'oeuvre",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Matin',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Michroma',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              const SizedBox(height: 10),
              buildTextFieldWithEditIcon(
                hintText: "Nombre d'Hommes",
                controller: _nombrehomme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargehomme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Femmes",
                controller: _nombrefemme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargefemme,
              ),
              const SizedBox(height: 15),
              const Text(
                'Aprés Midi',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Michroma',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              const SizedBox(height: 10),
              buildTextFieldWithEditIcon(
                hintText: "Nombre d'Hommes",
                controller: _nombrehomme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargehomme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Femmes",
                controller: _nombrefemme,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargefemme,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
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
              hintText: hintText,
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
