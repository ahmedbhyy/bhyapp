import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
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
              Padding(
                padding: const EdgeInsets.only(top: 150, left: 300),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FactureInfo(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.storage,
                    color: Colors.green,
                    size: 40,
                  ),
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


