import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteReglementInfo extends StatefulWidget {
  const NoteReglementInfo({super.key});

  @override
  State<NoteReglementInfo> createState() => _NoteReglementInfoState();
}

class _NoteReglementInfoState extends State<NoteReglementInfo> {
  final TextEditingController _nnn5 = TextEditingController();
  TextEditingController get controller => _nnn5;
  final TextEditingController _nomfournisseur = TextEditingController();
  final TextEditingController _numfacture = TextEditingController();
  final TextEditingController _montantfac = TextEditingController();
  final TextEditingController _modepaiment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _datedenote = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    _nomfournisseur.dispose();
    _numfacture.dispose();
    _montantfac.dispose();
    _modepaiment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Notes de Réglement",
          style: TextStyle(
            fontSize: 17.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter une Note";
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
                labelText: "chercher une Note Par (N° Facture)",
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
                    controller: _nomfournisseur,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom du Fournisseur',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _numfacture,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'N° Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _montantfac,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Montant de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.attach_money),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _modepaiment,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Mode de Paiment',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.payments),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  CalendarDatePicker(
                    initialDate: _datedenote,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datedenote = value;
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
                saveNoteData();
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveNoteData() async {
    try {
      String nomfournisseur = _nomfournisseur.text;
      String numfacture = _numfacture.text;
      String montantfac = _montantfac.text;
      String modepaiment = _modepaiment.text;

      await _firestore.collection('noteregle').doc().set({
        'nomfournisseur': nomfournisseur,
        'numfacture': numfacture,
        'montantfacture': montantfac,
        'modepaiment': modepaiment,
        'datenote': _datedenote.toString(),
      }, SetOptions(merge: true));
      setState(() {});

      print('Note data saved to Firestore');
    } catch (e) {
      print('Error saving Note data: $e');
    }
  }
}
