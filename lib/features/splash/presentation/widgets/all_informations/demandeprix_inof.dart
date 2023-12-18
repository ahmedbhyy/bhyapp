import 'package:flutter/material.dart';

class DemandePrixInfo extends StatefulWidget {
  const DemandePrixInfo({super.key});

  @override
  State<DemandePrixInfo> createState() => _DemandePrixInfoState();
}

class _DemandePrixInfoState extends State<DemandePrixInfo> {
  final TextEditingController _nnn4 = TextEditingController();
  TextEditingController get controller => _nnn4;
  final TextEditingController _dateprix = TextEditingController();
  final TextEditingController _nomdesociete4 = TextEditingController();
  final TextEditingController _quantiteprix = TextEditingController();
  final TextEditingController _descriprixadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateprix.dispose();
    _nomdesociete4.dispose();
    _descriprixadmin.dispose();
    _quantiteprix.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Demandes des Prix",
          style: TextStyle(
            fontSize: 18.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter un Demande d'offre";
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
              width: 350,
              child: Column(
                children: [
                  TextField(
                    controller: _dateprix,
                    decoration: const InputDecoration(
                      labelText: 'Date de Demande',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.date_range),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomdesociete4,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriprixadmin,
                    decoration: const InputDecoration(
                      labelText: 'Description de Demande',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _quantiteprix,
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.storage),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
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
