import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class DevisInfo extends StatefulWidget {
  const DevisInfo({super.key});

  @override
  State<DevisInfo> createState() => _DevisInfoState();
}

class _DevisInfoState extends State<DevisInfo> {
  final TextEditingController _nnn3 = TextEditingController();
  TextEditingController get controller => _nnn3;
  TextEditingController _datedeviss = TextEditingController();
  final TextEditingController _nomdesociete3 = TextEditingController();
  final TextEditingController _numdevisadmin = TextEditingController();
  final TextEditingController _descridevisadmin = TextEditingController();
  final TextEditingController _totaldevisadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _datedeviss.dispose();
    _nomdesociete3.dispose();
    _numdevisadmin.dispose();
    _descridevisadmin.dispose();
    _totaldevisadmin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Devis",
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
              String hintText = "Ajouter un Devis";
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
                      label: Text("Date de Devis"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        _datedeviss = date as TextEditingController;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomdesociete3,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numdevisadmin,
                    decoration: const InputDecoration(
                      labelText: 'N° Devis',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descridevisadmin,
                    decoration: const InputDecoration(
                      labelText: 'Description de Devis',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _totaldevisadmin,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
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
