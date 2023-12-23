import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class FactureAdminInfo extends StatefulWidget {
  const FactureAdminInfo({super.key});

  @override
  State<FactureAdminInfo> createState() => _FactureAdminInfoState();
}

class _FactureAdminInfoState extends State<FactureAdminInfo> {
  final TextEditingController _nnn2 = TextEditingController();
  TextEditingController get controller => _nnn2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _datefacadmin = DateTime.now();
  final TextEditingController _nomdesociete2 = TextEditingController();
  final TextEditingController _numfacadmin = TextEditingController();
  final TextEditingController _descrifacadmin = TextEditingController();
  final TextEditingController _totalfacadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _nomdesociete2.dispose();
    _numfacadmin.dispose();
    _descrifacadmin.dispose();
    _totalfacadmin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Facture (Centrale)",
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter une Facture Administrative";
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
                labelText: "chercher une Facture par (N°)",
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
                  TextField(
                    controller: _nomdesociete2,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _numfacadmin,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'N° Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _descrifacadmin,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _totalfacadmin,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.attach_money),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  CalendarDatePicker(
                    initialDate: _datefacadmin,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datefacadmin = value;
                    },
                    currentDate: DateTime.now(),
                  ),
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
              onPressed: () {
                savefacadminData();
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> savefacadminData() async {
    try {
      String nomsociete2 = _nomdesociete2.text;
      String numfacadmin = _numfacadmin.text;
      String descrifacadmin = _descrifacadmin.text;
      String totalfacadmin = _totalfacadmin.text;

      await _firestore.collection('adminfacture').doc().set({
        'nomsocietefac': nomsociete2,
        'numfacadmin': numfacadmin,
        'descrifacadmin': descrifacadmin,
        'totalfacadmin': totalfacadmin,
        'datefacadmin': _datefacadmin.toString(),
      }, SetOptions(merge: true));
      setState(() {});

      print('Offre data saved to Firestore');
    } catch (e) {
      print('Error saving Offre data: $e');
    }
  }
}
