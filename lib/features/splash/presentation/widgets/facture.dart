import 'dart:ffi';

import 'package:flutter/material.dart';

class Facture extends StatefulWidget {
  const Facture({super.key});

  @override
  State<Facture> createState() => _FactureState();
}

class _FactureState extends State<Facture> {
  final TextEditingController _numerodufacture = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _datefacture = TextEditingController();
  final TextEditingController _designation1 = TextEditingController();
  final TextEditingController _montant = TextEditingController();
  final TextEditingController _totalfacture = TextEditingController();
  final TextEditingController _quantite1 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _numerodufacture.dispose();
    _nomdesociete.dispose();
    _datefacture.dispose();
    _designation1.dispose();
    _quantite1.dispose();
    _montant.dispose();
    _totalfacture.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Factures',
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
              TextField(
                style: const TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  hintText: "chercher un N° du Facture",
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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Chercher'),
                ),
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "N° de la facture",
                controller: _numerodufacture,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Nom de la société",
                controller: _nomdesociete,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Date de la facture",
                controller: _datefacture,
              ),
              const SizedBox(height: 50),
              const TableExample(),
              const SizedBox(height: 50),
              buildTextFieldWithEditIcon(
                hintText: "Total de la facture",
                controller: _totalfacture,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8),
                child: ElevatedButton(
                  onPressed: () {},
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
              hintText: 'Entrer une valeur',
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
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}

class TableExample extends StatefulWidget {
  const TableExample({Key? key}) : super(key: key);

  @override
  State<TableExample> createState() => _TableExampleState();
}

class facturetable {
  // ignore: non_constant_identifier_names
  String? designation;
  int? quantite;
  double? montant;

  // ignore: non_constant_identifier_names
  facturetable({this.designation, this.quantite, this.montant});
}

class _TableExampleState extends State<TableExample> {
  List<facturetable> factures = [];
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(240),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: <TableRow>[
        const TableRow(
          children: <Widget>[
            TableCell(
              child: Center(
                child: Text(
                  'Désignation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  'Quantité',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  'Montant',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                hintText: 'Ecrire ici ',
              ),
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration.collapsed(
                hintText: 'Ecrire ici',
              ),
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration.collapsed(
                hintText: 'Ecrire ici ',
              ),
              maxLines: null,
            ),
          ],
        ),
        ...factures.map(
          (facturetable fact) => TableRow(
            children: <Widget>[
              TextFormField(
                initialValue: fact.designation,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  hintText: 'Ecrire ici ',
                ),
                maxLines: null,
              ),
              TextFormField(
                initialValue: fact.quantite.toString(),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ecrire ici',
                ),
                maxLines: null,
              ),
              TextFormField(
                initialValue: fact.montant.toString(),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ecrire ici ',
                ),
                maxLines: null,
              ),
            ],
          ),
        )
      ],
    );
  }
}
