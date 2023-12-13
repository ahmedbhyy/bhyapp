import 'package:flutter/material.dart';

class OuvrierPrime extends StatefulWidget {
  const OuvrierPrime({super.key});

  @override
  State<OuvrierPrime> createState() => _OuvrierPrimeState();
}

class _OuvrierPrimeState extends State<OuvrierPrime> {
  final TextEditingController _primeouvrier = TextEditingController();
  final TextEditingController _dateprimeouvrier = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _primeouvrier.dispose();
    _dateprimeouvrier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prime",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 35.0, left: 10, right: 10),
              child: TableExample(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Enregistrer'),
              ),
            ),
          ],
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
                  'Montant',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  'Date',
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
