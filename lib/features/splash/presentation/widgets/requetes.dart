import 'package:flutter/material.dart';

class Requetes extends StatefulWidget {
  const Requetes({super.key});

  @override
  State<Requetes> createState() => _RequetesState();
}

class _RequetesState extends State<Requetes> {
  final TextEditingController _administrative = TextEditingController();
  final TextEditingController _achatdivers = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _administrative.dispose();
    _achatdivers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requêtes',
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
              const SizedBox(height: 30),
              const TableExample(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 8),
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
}

class TableExample extends StatelessWidget {
  const TableExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(200),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        const TableRow(
          children: <Widget>[
            TableCell(
              child: Center(
                child: Text(
                  'Requêtes Administratives',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  'Achat Divers',
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
                  hintText: 'Description',
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
