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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: FactureSearch());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.green,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8),
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

class Facturetable {
  // ignore: non_constant_identifier_names
  String? designation;
  int? quantite;
  double? montant;

  // ignore: non_constant_identifier_names
  Facturetable({this.designation, this.quantite, this.montant});
}

class _TableExampleState extends State<TableExample> {
  List<Facturetable> factures = [
    Facturetable(designation: "test 1", montant: 120.5, quantite: 10)
  ];
  TableRow _generateRow(Facturetable fact, int index) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextFormField(
            onChanged: (val) {
              setState(() {
                factures[index].designation = val;
              });
            },
            initialValue: fact.designation,
            decoration: const InputDecoration.collapsed(
              hintText: 'Ecrire ici ',
            ),
            maxLines: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextFormField(
            onChanged: (val) {
              setState(() {
                factures[index].quantite = int.parse(val);
              });
            },
            initialValue: fact.quantite.toString(),
            decoration: const InputDecoration.collapsed(
              hintText: 'Ecrire ici',
            ),
            maxLines: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextFormField(
            onFieldSubmitted: (String _) {
              setState(() {
                factures.add(
                    Facturetable(designation: "", montant: 0, quantite: 0));
              });
            },
            onChanged: (val) {
              setState(() {
                factures[index].montant = double.parse(val);
              });
            },
            textInputAction: TextInputAction.done,
            initialValue: fact.montant.toString(),
            decoration: const InputDecoration.collapsed(
              hintText: 'Ecrire ici ',
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(170),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'Quantité',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      'Montant',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            ...factures.asMap().entries.map(
                  (entry) => _generateRow(entry.value, entry.key),
                )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Text(
            'Total de la Facture en DT : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            factures.fold(
              "0",
              (pv, element) => (double.parse(pv) +
                      (element.montant ?? 0) * (element.quantite ?? 0))
                  .toString(),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}

class FactureSearch extends SearchDelegate {
  List<String> allData = [
    '2521',
    '12154',
    '6566',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
