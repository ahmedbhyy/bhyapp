import 'package:flutter/material.dart';

class BonSortie extends StatefulWidget {
  const BonSortie({super.key});

  @override
  State<BonSortie> createState() => _BonSortieState();
}

class _BonSortieState extends State<BonSortie> {
  final TextEditingController _numerodubon = TextEditingController();
  final TextEditingController _beneficiaire = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _quantite = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _numerodubon.dispose();
    _beneficiaire.dispose();
    _destination.dispose();
    _designation.dispose();
    _quantite.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bon de sortie interne',
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
              showSearch(context: context, delegate: BonsortieSearch());
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
              buildTextFieldWithEditIcon(
                hintText: "N° du bon",
                controller: _numerodubon,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Bénéficiaire",
                controller: _beneficiaire,
              ),
              const SizedBox(height: 20),
              buildTextFieldWithEditIcon(
                hintText: "Destination",
                controller: _destination,
              ),
              const SizedBox(height: 40),
              const TableExample(),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 8),
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
      ],
    );
  }
}

class TableExample extends StatelessWidget {
  const TableExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(280),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
          ],
        ),
      ],
    );
  }
}

class BonsortieSearch extends SearchDelegate {
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
