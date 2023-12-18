import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class FactureAdminInfo extends StatefulWidget {
  const FactureAdminInfo({super.key});

  @override
  State<FactureAdminInfo> createState() => _FactureAdminInfoState();
}

class _FactureAdminInfoState extends State<FactureAdminInfo> {
  final TextEditingController _nnn2 = TextEditingController();
  TextEditingController get controller => _nnn2;
  TextEditingController _datefacadmin = TextEditingController();
  final TextEditingController _nomdesociete2 = TextEditingController();
  final TextEditingController _numfacadmin = TextEditingController();
  final TextEditingController _descrifacadmin = TextEditingController();
  final TextEditingController _totalfacadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _datefacadmin.dispose();
    _nomdesociete2.dispose();
    _numfacadmin.dispose();
    _descrifacadmin.dispose();
    _totalfacadmin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Facture d'Admin",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter une Facture Administrative";
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
                  DateFormatField(
                    type: DateFormatType.type2,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      label: Text("Date de Facture"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        _datefacadmin = date as TextEditingController;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomdesociete2,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numfacadmin,
                    decoration: const InputDecoration(
                      labelText: 'N° Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descrifacadmin,
                    decoration: const InputDecoration(
                      labelText: 'Description de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _totalfacadmin,
                    decoration: const InputDecoration(
                      labelText: 'Total de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.attach_money),
                      suffixText: 'DT',
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
