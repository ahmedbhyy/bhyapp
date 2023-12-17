import 'package:flutter/material.dart';

class BonCommandeInfo extends StatefulWidget {
  const BonCommandeInfo({super.key});

  @override
  State<BonCommandeInfo> createState() => _BonCommandeInfoState();
}

class _BonCommandeInfoState extends State<BonCommandeInfo> {
  final TextEditingController _nnn = TextEditingController();
  TextEditingController get controller => _nnn;
  final TextEditingController _dateboncomm = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _designation2 = TextEditingController();
  final TextEditingController _quantite2 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateboncomm.dispose();
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
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(hintText),
            content: SizedBox(
              width: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _dateboncomm,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.date_range),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomdesociete,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _designation2,
                    decoration: const InputDecoration(
                      labelText: 'Désignation',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _quantite2,
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                ],
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
          ),
        );
      },
    );
  }
}
