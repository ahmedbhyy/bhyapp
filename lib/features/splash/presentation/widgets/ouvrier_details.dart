import 'package:flutter/material.dart';

class OuvrierDetails extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Ouvriername;

  // ignore: non_constant_identifier_names
  const OuvrierDetails({Key? key, required this.Ouvriername}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OuvrierDetails createState() => _OuvrierDetails();
}

class _OuvrierDetails extends State<OuvrierDetails> {
  final TextEditingController _primeController = TextEditingController();
  final TextEditingController _congesController = TextEditingController();
  final TextEditingController _hsController = TextEditingController();
  final TextEditingController _voyageController = TextEditingController();
  final TextEditingController _deplacementController = TextEditingController();

  @override
  void dispose() {
    _primeController.dispose();
    _congesController.dispose();
    _hsController.dispose();
    _voyageController.dispose();
    _deplacementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.Ouvriername,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Michroma',
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                buildTextFieldWithEditIcon(
                  hintText: "Prime",
                  controller: _primeController,
                ),
                const SizedBox(height: 20),
                buildTextFieldWithEditIcon(
                  hintText: "Congés de travail",
                  controller: _congesController,
                ),
                const SizedBox(height: 20),
                buildTextFieldWithEditIcon(
                  hintText: "Heures supplémentaires",
                  controller: _hsController,
                ),
                const SizedBox(height: 20),
                buildTextFieldWithEditIcon(
                  hintText: "Voyages et Diesel",
                  controller: _voyageController,
                ),
                const SizedBox(height: 20),
                buildTextFieldWithEditIcon(
                  hintText: "Déplacements",
                  controller: _deplacementController,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ));
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
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showEditDialog(context, hintText, controller);
          },
        ),
      ],
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $hintText'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new value',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the edited value
                // For example, you can update the corresponding variable or send it to a server
                // ignore: avoid_print
                print('Edited value: ${controller.text}');
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
