import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class FactureInfo extends StatefulWidget {
  const FactureInfo({super.key});

  @override
  State<FactureInfo> createState() => _FactureInfoState();
}

class _FactureInfoState extends State<FactureInfo> {
  final TextEditingController _numfacc = TextEditingController();
  TextEditingController get controller => _numfacc;
  final TextEditingController _numerodufacture = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  TextEditingController _datefacture = TextEditingController();
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

  List<Facture> mainfacList = [
    Facture(
        numerodufacture: "52854",
        nomdesociete: "fdff",
        datefacture: "jerba",
        designation1: "erezez",
        montant: "20",
        totalfacture: "20",
        quantite1: "20"),
    Facture(
        numerodufacture: "587411",
        nomdesociete: "xsde",
        datefacture: "sfax",
        designation1: "efzef",
        montant: "54",
        totalfacture: "20",
        quantite1: "20"),
    Facture(
        numerodufacture: "584487411",
        nomdesociete: "xsdfesde",
        datefacture: "sfdadax",
        designation1: "efzdqsdef",
        montant: "5435",
        totalfacture: "20",
        quantite1: "20"),
  ];
  List<Facture> displayList = [];
  @override
  void initState() {
    displayList = List.from(mainfacList);
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      displayList = mainfacList
          .where(
              (element) => element.numerodufacture.toString().contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Factures",
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
              String hintText = "Ajouter une Facture";
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
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => updateList(value),
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                labelText: "chercher une facture (N°)",
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
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: displayList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                title: Text(
                  displayList[index].numerodufacture ?? "No Name",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(hintText),
            content: SizedBox(
              width: 300,
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
                      label: Text("Date du Facture"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        _datefacture = date as TextEditingController;
                      });
                    },
                  ),
                  TextField(
                    controller: _numerodufacture,
                    decoration: const InputDecoration(
                      labelText: 'N° de la facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomdesociete,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _designation1,
                                decoration: const InputDecoration(
                                  labelText: 'Désignation',
                                  labelStyle: TextStyle(fontSize: 17),
                                ),
                                maxLines: null,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 2,
                              indent: 25,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _quantite1,
                                decoration: const InputDecoration(
                                  labelText: 'Quantité',
                                  labelStyle: TextStyle(fontSize: 17),
                                ),
                                maxLines: null,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 2,
                              indent: 25,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _montant,
                                decoration: const InputDecoration(
                                  labelText: 'Montant',
                                  labelStyle: TextStyle(fontSize: 17),
                                ),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  TextField(
                    controller: _totalfacture,
                    decoration: const InputDecoration(
                      labelText: 'Total',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.euro),
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

class Facture {
  // ignore: non_constant_identifier_names
  String? numerodufacture;
  // ignore: non_constant_identifier_names
  String? nomdesociete;
  // ignore: non_constant_identifier_names
  String? datefacture;
  // ignore: non_constant_identifier_names
  String? designation1;
  // ignore: non_constant_identifier_names
  String? montant;
  String? totalfacture;
  String? quantite1;
  // ignore: non_constant_identifier_names
  Facture(
      {this.numerodufacture,
      this.nomdesociete,
      this.datefacture,
      this.designation1,
      this.montant,
      this.totalfacture,
      this.quantite1});
}
