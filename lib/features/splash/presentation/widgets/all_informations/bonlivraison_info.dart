import 'package:flutter/material.dart';

class BonLivraisonInfo extends StatefulWidget {
  const BonLivraisonInfo({super.key});

  @override
  State<BonLivraisonInfo> createState() => _BonLivraisonInfoState();
}

class _BonLivraisonInfoState extends State<BonLivraisonInfo> {
  final TextEditingController _nnn1 = TextEditingController();
  TextEditingController get controller => _nnn1;
  final TextEditingController _datebonliv = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _numbonliv = TextEditingController();
  final TextEditingController _descrip = TextEditingController();
  final TextEditingController _total = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _datebonliv.dispose();
    _nomdesociete.dispose();
    _numbonliv.dispose();
    _descrip.dispose();
    _total.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Livraison",
          style: TextStyle(
            fontSize: 19.8,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter un Bon de Livraison";
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
                    controller: _datebonliv,
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
                        icon: Icon(Icons.work)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numbonliv,
                    decoration: const InputDecoration(
                        labelText: 'N° du Bon',
                        labelStyle: TextStyle(fontSize: 20),
                        icon: Icon(Icons.numbers)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descrip,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _total,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.euro),
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
