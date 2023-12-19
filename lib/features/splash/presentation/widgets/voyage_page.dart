import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:flutter/material.dart';

class Voyages extends StatefulWidget {
  final Voyage transport;
  final Future<void> Function(Voyage) update;
  const Voyages({Key? key, required this.transport, required this.update})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VoyagesState createState() => _VoyagesState();
}

class _VoyagesState extends State<Voyages> {
  final TextEditingController _nombrevoyage = TextEditingController();
  final TextEditingController _coutvoyage = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _nombrevoyage.dispose();
    _coutvoyage.dispose();
  }

  @override
  void initState() {
    _nombrevoyage.text = widget.transport.nombres.toString();
    _coutvoyage.text = widget.transport.cout.toString();
    super.initState();
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
                  suffixText: 'Voyages'),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                  hintText: "Cout", controller: _coutvoyage, suffixText: 'DT'),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8),
                child: ElevatedButton(
                  onPressed: () {
                    final tmp = Voyage(
                        nombres: int.parse(_nombrevoyage.text),
                        cout: double.parse(_coutvoyage.text));
                    widget.update(tmp);
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
    required String suffixText,
  }) {
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
              suffixText: suffixText,
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
