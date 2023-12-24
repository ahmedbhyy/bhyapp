import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteReglementInfo extends StatefulWidget {
  const NoteReglementInfo({super.key});

  @override
  State<NoteReglementInfo> createState() => _NoteReglementInfoState();
}

class _NoteReglementInfoState extends State<NoteReglementInfo> {
  final TextEditingController _nomfournisseur = TextEditingController();
  final TextEditingController _numfacture = TextEditingController();
  final TextEditingController _montantfac = TextEditingController();
  final TextEditingController _modepaiment = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime _datedenote = DateTime.now();
  List<Note> notes = [];
  List<Note> displaynoteslList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displaynoteslList = List.from(notes);
      } else {
        displaynoteslList = notes
            .where((element) => element.numfacture.contains(value))
            .toList();
      }
    });
  }

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
            onPressed: () async {
              final data = await showEditDialog(context);
              if (data != null) {
                saveData(data);
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.green,
              size: Platform.isAndroid ? 32 : 45,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => updateList(value),
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                labelText:
                    "chercher une Note Par (N° Facture (${displaynoteslList.length}))",
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
          Expanded(
            child: ListView.separated(
              itemCount: displaynoteslList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final note = displaynoteslList[index];
                return ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(note.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(
                      "Nom de Fournisseur : ${note.nomfournisseur.toString()}\nN° Facture : ${note.numfacture}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Confirm Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this item?',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await deletenoteregle(notes[index].numfacture);
                                setState(() {
                                  notes.removeAt(index);
                                  updateList('');
                                });
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onTap: () async {
                    _nomfournisseur.text = note.nomfournisseur;
                    _numfacture.text = note.numfacture;
                    _montantfac.text = note.montantfacture.toString();
                    _modepaiment.text = note.modepaiment;
                    _datedenote = note.date;
                    final res = await showEditDialog(context, modify: true);
                    _nomfournisseur.clear();
                    _numfacture.clear();
                    _montantfac.clear();
                    _modepaiment.clear();
                    _datedenote = DateTime.now();
                    if (res != null) {
                      notes[index] = res;
                      saveData(res, index: index, modify: true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deletenoteregle(String noteId) async {
    try {
      final db = FirebaseFirestore.instance;
      final noteRef = db.collection('noteregle').doc(noteId);

      await noteRef.delete();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement")));
    }
  }

  Future<Note?> showEditDialog(BuildContext context,
      {bool modify = false}) async {
    return showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify ? "modifier une note" : "ajouter une Note"),
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
                    enabled: !modify,
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
                String nomfournisseur = _nomfournisseur.text;
                String numfacture = _numfacture.text;
                String montantfac = _montantfac.text;
                String modepaiment = _modepaiment.text;

                if (nomfournisseur.isEmpty ||
                    numfacture.isEmpty ||
                    montantfac.isEmpty ||
                    modepaiment.isEmpty) return;

                final tmp = Note(
                    date: _datedenote,
                    modepaiment: modepaiment,
                    montantfacture: double.parse(montantfac),
                    nomfournisseur: nomfournisseur,
                    numfacture: numfacture);

                Navigator.pop(context, tmp);
              },
              child: Text(modify ? "modifier" : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveData(Note tmp, {bool modify = false, int index = -1}) async {
    try {
      await db
          .collection('noteregle')
          .doc(tmp.numfacture)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          notes.add(tmp);
        } else {
          if (index >= 0) {
            notes[index] = tmp;
          }
        }
        updateList('');
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement")));
    }
  }

  Future<void> fetchData() async {
    final docs = await db.collection('noteregle').get();
    setState(() {
      notes = List<Note>.from(docs.docs.map((e) => Note.fromMap(e)).toList());
      updateList('');
    });
  }
}

class Note {
  final String nomfournisseur;
  final String numfacture;
  final double montantfacture;
  final String modepaiment;
  final DateTime date;

  Note(
      {required this.date,
      required this.modepaiment,
      required this.montantfacture,
      required this.nomfournisseur,
      required this.numfacture});

  Map<String, dynamic> toMap() {
    return {
      'nomfournisseur': nomfournisseur,
      'numfacture': numfacture,
      'montantfacture': montantfacture,
      'modepaiment': modepaiment,
      'date': date.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(
      date: DateTime.parse(e["date"]),
      modepaiment: e["modepaiment"],
      montantfacture: e["montantfacture"],
      nomfournisseur: e["nomfournisseur"],
      numfacture: e["numfacture"],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
