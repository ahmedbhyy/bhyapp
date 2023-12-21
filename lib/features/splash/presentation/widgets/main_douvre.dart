import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Maindoeuvre extends StatefulWidget {
  final Oeuvre oeuvre;
  final Future<void> Function(Oeuvre) updateremotestate;
  const Maindoeuvre(
      {super.key, required this.oeuvre, required this.updateremotestate});

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
  void initState() {
    print(widget.oeuvre.midi_homme);
    _nombrehomme.text = widget.oeuvre.matin_homme.toString();
    _nombrehomme2.text = widget.oeuvre.midi_homme.toString();
    _nombrefemme.text = widget.oeuvre.matin_femme.toString();
    _nombrefemme2.text = widget.oeuvre.midi_femme.toString();
    _chargehomme.text = widget.oeuvre.matin_charge_homme.toString();
    _chargefemme.text = widget.oeuvre.matin_charge_femme.toString();
    _chargefemme2.text = widget.oeuvre.midi_charge_femme.toString();
    _chargehomme2.text = widget.oeuvre.midi_charge_homme.toString();
    super.initState();
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
                iconData: Icons.man,
                suffixText: '',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge homme",
                controller: _chargehomme,
                iconData: Icons.euro,
                suffixText: 'DT',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Femmes",
                controller: _nombrefemme,
                iconData: Icons.woman,
                suffixText: '',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge femme",
                controller: _chargefemme,
                iconData: Icons.euro,
                suffixText: 'DT',
              ),
              const SizedBox(
                height: 20,
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
                iconData: Icons.man,
                suffixText: '',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge homme",
                controller: _chargehomme2,
                iconData: Icons.euro,
                suffixText: 'DT',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nombre de Femmes",
                controller: _nombrefemme2,
                iconData: Icons.woman,
                suffixText: '',
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Charge femme",
                controller: _chargefemme2,
                iconData: Icons.euro,
                suffixText: 'DT',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 250),
                child: ElevatedButton(
                  onPressed: () {
                    Oeuvre tmp = Oeuvre(
                      matin_homme: int.parse(_nombrehomme.text),
                      matin_femme: int.parse(_nombrefemme.text),
                      matin_charge_homme: double.parse(_chargehomme.text),
                      matin_charge_femme: double.parse(_chargefemme.text),
                      midi_homme: int.parse(_nombrehomme2.text),
                      midi_femme: int.parse(_nombrefemme2.text),
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

  Widget buildTextFieldWithEditIcon({
    required String hintText,
    required TextEditingController controller,
    required IconData iconData,
    required String suffixText,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              labelText: hintText,
              suffixText: suffixText,
              suffixStyle: const TextStyle(fontSize: 20),
              prefixIcon: Icon(iconData),
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
