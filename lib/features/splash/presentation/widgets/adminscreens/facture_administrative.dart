import 'package:flutter/material.dart';

class AdminFacture extends StatefulWidget {
  const AdminFacture({super.key});

  @override
  State<AdminFacture> createState() => _AdminFactureState();
}

class _AdminFactureState extends State<AdminFacture> {
  final TextEditingController _datefacture = TextEditingController();
  final TextEditingController _montantfacture = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _datefacture.dispose();
    _montantfacture.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Facture",
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
              showSearch(context: context, delegate: FactureAdminSearch());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.green,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Date",
                controller: _datefacture,
              ),
              const SizedBox(height: 20),
              const TableExample4(),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Montant Total",
                controller: _montantfacture,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8),
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
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TableExample4 extends StatelessWidget {
  const TableExample4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(120),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        const TableRow(
          children: <Widget>[
            TableCell(
              child: Center(
                child: Text(
                  'Société',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TableCell(
                child: Center(
                  child: Text(
                    'Numéro de la Facture',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ecrire ici ',
                ),
                maxLines: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ecrire ici',
                ),
                maxLines: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ecrire ici ',
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FactureAdminSearch extends SearchDelegate {
  List<String> allData = [
    '875120',
    '587554',
    '265987',
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
