import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class DemandePrixInfo extends StatefulWidget {
  const DemandePrixInfo({super.key});

  @override
  State<DemandePrixInfo> createState() => _DemandePrixInfoState();
}

class _DemandePrixInfoState extends State<DemandePrixInfo> {
  final TextEditingController _nnn4 = TextEditingController();
  TextEditingController get controller => _nnn4;
  DateTime? _dateprix;
  final TextEditingController _nomdesociete4 = TextEditingController();
  final TextEditingController _quantiteprix = TextEditingController();
  final TextEditingController _descriprixadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                labelText: "chercher une Demande par (Date)",
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
          content: SingleChildScrollView(
            child: SizedBox(
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
                      label: Text("Date de Demande"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        if (date != null) {
                          _dateprix = date;
                        }
                      });
                    },
                  ),
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
                    keyboardType: TextInputType.number,
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
