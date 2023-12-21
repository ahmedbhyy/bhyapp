import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class BonCommandeInfo extends StatefulWidget {
  const BonCommandeInfo({super.key});

  @override
  State<BonCommandeInfo> createState() => _BonCommandeInfoState();
}

class _BonCommandeInfoState extends State<BonCommandeInfo> {
  final TextEditingController _nnn = TextEditingController();
  TextEditingController get controller => _nnn;
  DateTime? _dateboncomm;
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _designation2 = TextEditingController();
  final TextEditingController _quantite2 = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _nomdesociete.dispose();
    _designation2.dispose();
    _quantite2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Commande",
          style: TextStyle(
            fontSize: 17.6,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter un Bon de Commande";
              showEditDialog(context, hintText, controller);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.green,
              size: 35,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                labelText: "chercher un Bon Commande par (Date)",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hintText),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DateFormatField(
                    type: DateFormatType.type2,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      label: Text("Date du Bon"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        if (date != null) {
                          _dateboncomm = date;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nomdesociete,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _designation2,
                                decoration: const InputDecoration(
                                  labelText: 'Désignation',
                                  labelStyle: TextStyle(fontSize: 20),
                                ),
                                maxLines: null,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 2,
                              indent: 25,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _quantite2,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Quantité',
                                  labelStyle: TextStyle(fontSize: 20),
                                ),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 250),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
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
              onPressed: () {},
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
