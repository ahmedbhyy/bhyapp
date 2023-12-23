import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class BonLivraisonInfo extends StatefulWidget {
  const BonLivraisonInfo({super.key});

  @override
  State<BonLivraisonInfo> createState() => _BonLivraisonInfoState();
}

class _BonLivraisonInfoState extends State<BonLivraisonInfo> {
  final TextEditingController _nnn1 = TextEditingController();
  TextEditingController get controller => _nnn1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _datebonliv = DateTime.now();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _numbonliv = TextEditingController();
  final TextEditingController _descrip = TextEditingController();
  final TextEditingController _total = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nomdesociete.dispose();
    _numbonliv.dispose();
    _descrip.dispose();
    _total.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Livraison",
          style: TextStyle(
            fontSize: 19.8,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter un Bon de Livraison";
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
                labelText: "chercher un Bon Livraison par (N°)",
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
              width: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _nomdesociete,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        labelText: 'Nom de la société',
                        labelStyle: TextStyle(fontSize: 20),
                        icon: Icon(Icons.work)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _numbonliv,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'N° du Bon',
                        labelStyle: TextStyle(fontSize: 20),
                        icon: Icon(Icons.numbers)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _descrip,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _total,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.euro),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  CalendarDatePicker(
                    initialDate: _datebonliv,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datebonliv = value;
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
                savebonlivData();
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> savebonlivData() async {
    try {
      String nomsociete = _nomdesociete.text;
      String numbonliv = _numbonliv.text;
      String descrip = _descrip.text;
      String total = _total.text;

      await _firestore.collection('bonlivraison').doc().set({
        'nomsocieteliv': nomsociete,
        'numbonliv': numbonliv,
        'descripliv': descrip,
        'totalliv': total,
        'dateliv': _datebonliv.toString(),
      }, SetOptions(merge: true));
      setState(() {});

      print('Offre data saved to Firestore');
    } catch (e) {
      print('Error saving Offre data: $e');
    }
  }
}
