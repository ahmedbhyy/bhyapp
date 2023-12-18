import 'package:flutter/material.dart';

class Voyages extends StatefulWidget {
  const Voyages({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VoyagesState createState() => _VoyagesState();
}

class _VoyagesState extends State<Voyages> {
  final TextEditingController _nombrevoyage = TextEditingController();
  final TextEditingController _descvoyage = TextEditingController();
  final TextEditingController _coutvoyage = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _nombrevoyage.dispose();
    _coutvoyage.dispose();
    _descvoyage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Transport",
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
              const SizedBox(height: 15),
              const Text(
                'Les Transports d\'Aujourdhui',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Michroma',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Voyages",
                controller: _nombrevoyage,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Description des Voyages",
                controller: _descvoyage,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Cout",
                controller: _coutvoyage,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8),
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
