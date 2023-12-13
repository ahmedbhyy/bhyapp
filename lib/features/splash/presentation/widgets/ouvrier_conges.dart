import 'package:flutter/material.dart';

class CongesOuvrier extends StatefulWidget {
  const CongesOuvrier({super.key});

  @override
  State<CongesOuvrier> createState() => _CongesOuvrierState();
}

class _CongesOuvrierState extends State<CongesOuvrier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Congés de Travail",
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
        0: FixedColumnWidth(240),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        const TableRow(
          children: <Widget>[
            TableCell(
              child: Center(
                child: Text(
                  'Cause',
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
