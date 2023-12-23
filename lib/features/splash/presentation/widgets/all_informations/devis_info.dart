import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class DevisInfo extends StatefulWidget {
  const DevisInfo({super.key});

  @override
  State<DevisInfo> createState() => _DevisInfoState();
}

class _DevisInfoState extends State<DevisInfo> {
  final TextEditingController _nnn3 = TextEditingController();
  TextEditingController get controller => _nnn3;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _datedeviss = DateTime.now();
  final TextEditingController _nomdesociete3 = TextEditingController();
  final TextEditingController _numdevisadmin = TextEditingController();
  final TextEditingController _descridevisadmin = TextEditingController();
  final TextEditingController _totaldevisadmin = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nomdesociete3.dispose();
    _numdevisadmin.dispose();
    _descridevisadmin.dispose();
    _totaldevisadmin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Devis",
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
              String hintText = "Ajouter un Devis";
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
                labelText: "chercher un Devis par (N°)",
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
                    controller: _nomdesociete3,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    controller: _numdevisadmin,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'N° Devis',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    controller: _descridevisadmin,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description de Devis',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    controller: _totaldevisadmin,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.attach_money),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 5),
                  CalendarDatePicker(
                    initialDate: _datedeviss,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datedeviss = value;
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
                saveDevisData();
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDevisData() async {
    try {
      String nomsociete3 = _nomdesociete3.text;
      String numdevis = _numdevisadmin.text;
      String descridevisadmin = _descridevisadmin.text;
      String totaldevis = _totaldevisadmin.text;

      await _firestore.collection('devis').doc().set({
        'nomsocietedevis': nomsociete3,
        'numdevis': numdevis,
        'descridevis': descridevisadmin,
        'totaldevis': totaldevis,
        'datedevis': _datedeviss.toString(),
      }, SetOptions(merge: true));
      setState(() {});

      print('Offre data saved to Firestore');
    } catch (e) {
      print('Error saving Offre data: $e');
    }
  }
}
