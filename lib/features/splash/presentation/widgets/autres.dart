import 'package:flutter/material.dart';

class Autres extends StatefulWidget {
  final String autres;
  final Future<void> Function(String) updatestate;
  const Autres({super.key, required this.autres, required this.updatestate});

  @override
  State<Autres> createState() => _AutresState();
}

class _AutresState extends State<Autres> {
  final TextEditingController _autredetaile = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _autredetaile.dispose();
  }

  @override
  void initState() {
    _autredetaile.text = widget.autres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Autres",
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
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Détails",
                controller: _autredetaile,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8),
                child: ElevatedButton(
                  onPressed: () {
                    widget.updatestate(_autredetaile.text);
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
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
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
