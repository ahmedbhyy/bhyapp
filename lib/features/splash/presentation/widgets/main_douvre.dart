import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Maindoeuvre extends StatefulWidget {
  final Oeuvre oeuvre;
  final Future<void> Function(Oeuvre) updateremotestate;
  const Maindoeuvre({super.key, required this.oeuvre, required this.updateremotestate});

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
          padding: const EdgeInsets.all(8.0),
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
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 250),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Enregistrer'),
                ),
              ),
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
                controller: _nombrehomme2,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargehomme2,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Femmes",
                controller: _nombrefemme2,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge",
                controller: _chargefemme2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 250),
                child: ElevatedButton(
                  onPressed: () {
                    Oeuvre tmp = Oeuvre(
                        matin_homme: int.parse(_nombrehomme.text),
                        matin_femme: int.parse(_nombrehomme.text),
                        matin_charge_homme: double.parse(_chargehomme.text),
                        matin_charge_femme: double.parse(_chargefemme.text),
                        midi_homme: int.parse(_nombrehomme2.text),
                        midi_femme: int.parse(_nombrehomme2.text),
                        midi_charge_homme: double.parse(_chargehomme2.text),
                        midi_charge_femme: double.parse(_chargefemme2.text),
                    );
                    widget.updateremotestate(tmp);
                  },
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
              hintStyle: const TextStyle(fontSize: 25),
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
