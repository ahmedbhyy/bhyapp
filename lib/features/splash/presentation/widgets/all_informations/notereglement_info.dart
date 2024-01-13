import 'dart:io';

import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteReglementInfo extends StatefulWidget {
  final UserLocal? user;
  const NoteReglementInfo({super.key, this.user});

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
  int num = 0;

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
            .where((element) => Utils.factNum(element.toFacture()).contains(value))
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
              final db = FirebaseFirestore.instance;
              final doc = await db.collection('metadata').doc("note").get();
              setState(() {
                num = doc.data()!['next'];
                _numfacture.text = Utils.intFixed(num) + '/' + DateTime.now().year.toString();
              });
              if(!context.mounted) return;
              final data = await showEditDialog(context);
              if (data != null) {
                saveData(data);
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.green,
              size: Platform.isAndroid ? 32 : 55,
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
                    '${DateFormat('yyyy-MM-dd').format(note.date)}\nCreer Par : ${note.creerpar} le ${Utils.formatDate(note.date)}\n${note.modifierpar.isEmpty ? '' : 'Modifier Par : ${note.modifierpar} le ${Utils.formatDate(note.datemodif)}'}',
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(
                      "Nom de Fournisseur : ${note.fournisseur.toString()}\nN° Facture : ${note.num}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    _nomfournisseur.text = note.fournisseur;
                    _numfacture.text = Utils.factNum(note.toFacture());
                    _montantfac.text = note.montant.toString();
                    _modepaiment.text = note.modepaiment;
                    _datedenote = note.date;
                    final res = await showEditDialog(context, modify: true, note:note);
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

  Future<Note?> showEditDialog(BuildContext context,
      {bool modify = false, Note? note}) async {
    return showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify ? "Modifier une note" : "Ajouter une Note"),
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
                    enabled: false,
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
                String numfacture = _numfacture.text.replaceAll('/', '-');
                String montantfac = _montantfac.text;
                String modepaiment = _modepaiment.text;

                if (nomfournisseur.isEmpty ||
                    numfacture.isEmpty ||
                    montantfac.isEmpty ||
                    modepaiment.isEmpty) return;

                final tmp = Note(
                    modifierpar: modify ? widget.user!.name : '',
                    creerpar: modify ? note!.creerpar : widget.user!.name,
                    date: modify ? note!.date : _datedenote,
                    datemodif: DateTime.now(),
                    modepaiment: modepaiment,
                    montant: double.parse(montantfac),
                    fournisseur: nomfournisseur,
                    num: modify ? note!.num : num);

                Navigator.pop(context, tmp);
              },
              child: Text(modify ? "Modifier" : 'Enregistrer'),
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
          .doc(tmp.id)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          notes.add(tmp);
          db.collection('metadata').doc('note').update({'next': tmp.num+1});

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
  final String modifierpar;
  final String creerpar;
  final String fournisseur;
  final int num;
  final double montant;
  final String modepaiment;
  final DateTime date;
  final DateTime datemodif;
  String get id => num.toString()+date.year.toString();

  Note(
      {required this.date,
      required this.datemodif,
      this.modifierpar = "",
      required this.creerpar,
      required this.modepaiment,
      required this.montant,
      required this.fournisseur,
      required this.num});

  Map<String, dynamic> toMap() {
    return {
      'nomfournisseur': fournisseur,
      'numfacture': num,
      "modifierpar": modifierpar,
      "creerpar": creerpar,
      'montantfacture': montant,
      'modepaiment': modepaiment,
      'date': date.toString(),
      'datemodif': datemodif.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Note(
      modifierpar: e["modifierpar"],
      creerpar: e["creerpar"],
      date: DateTime.parse(e["date"]),
      datemodif: DateTime.parse(e["datemodif"]),
      modepaiment: e["modepaiment"],
      montant: e["montantfacture"],
      fournisseur: e["nomfournisseur"],
      num: e["numfacture"],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
  Facture toFacture() => Facture(nomsoc: "", total: 0, date: date, datemodif: datemodif, creerpar: creerpar, num: num, items: [], firm: '');
}
