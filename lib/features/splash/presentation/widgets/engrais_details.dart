import 'package:bhyapp/features/splash/presentation/widgets/engrais_commandes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EngraisDetails extends StatefulWidget {
  final String engraisName;
  final String id;
  EngraisDetails({Key? key, required this.engraisName, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EngraisDetailsState createState() => _EngraisDetailsState();
}

class _EngraisDetailsState extends State<EngraisDetails> {
  final TextEditingController _achatController = TextEditingController();
  final TextEditingController _venteController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  List<String> commandes = [];

  @override
  void dispose() {
    _achatController.dispose();
    _venteController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final engrais = db.collection("engrais").doc(widget.id);
    engrais.get().then((value) {
      setState(() {
        _venteController.text = (value.data()?["priv"] ?? 0).toString();
        _achatController.text = (value.data()?["pria"] ?? 0).toString();
        _quantiteController.text = (value.data()?["quantity"] ?? 0).toString();
        commandes =  List<String>.from(value.data()?["commandes"]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.engraisName,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildTextFieldWithEditIcon(
              hintText: "Prix d'Achat",
              controller: _achatController,
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Prix de Vente",
              controller: _venteController,
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Quantités",
              controller: _quantiteController,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                final prixa = double.parse(_achatController.value.text);
                final prixv = double.parse(_venteController.value.text);
                final quantite = int.parse(_quantiteController.value.text);

                final db = FirebaseFirestore.instance;
                final details = db.collection("engrais").doc(widget.id);

                details.update({
                  'priv': prixv,
                  'pria': prixa,
                  'quantity': quantite
                });

              },
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Commandes(commandes: commandes)),
                );
              },
              child: const Text('Les Commandes'),
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
            keyboardType: TextInputType.number,
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
