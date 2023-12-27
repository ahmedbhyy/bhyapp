import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DemandePrixInfo extends StatefulWidget {
  const DemandePrixInfo({super.key});

  @override
  State<DemandePrixInfo> createState() => _DemandePrixInfoState();
}

class _DemandePrixInfoState extends State<DemandePrixInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime date = DateTime.now();
  final TextEditingController _nomsoc = TextEditingController();
  final TextEditingController _quantite = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  List<Demande> demandes = [];
  List<Demande> displaydemandeslList = [];

  @override
  void initState() {
    fetchOffreData();
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displaydemandeslList = List.from(demandes);
      } else {
        displaydemandeslList = demandes
            .where((element) =>
                element.nomsociete.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nomsoc.dispose();
    _desc.dispose();
    _quantite.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Demandes des Prix",
          style: TextStyle(
            fontSize: 18.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final dem = await showEditDialog(context);
              if (dem != null) {
                saveOffreData(dem);
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
                    "chercher une Demande par (Société (${displaydemandeslList.length}))",
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
              itemCount: displaydemandeslList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final demande = displaydemandeslList[index];
                return ListTile(
                  leading: Icon(
                    Icons.payments,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(demande.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text('Société: ${demande.nomsociete.toString()}',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
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
                            'Confirmer la Suppression',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          content: const Text(
                            'Vous êtes sûr ?',
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
                                await deletedemandeprix(demandes[index].id);
                                setState(() {
                                  demandes.removeAt(index);
                                  updateList('');
                                });
                              },
                              child: const Text('Supprimer'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onTap: () async {
                    _nomsoc.text = demande.nomsociete;
                    _desc.text = demande.description;
                    _quantite.text = demande.quantiteprix.toString();
                    date = demande.date;
                    final res = await showEditDialog(context,
                        modify: true, demande: demande);
                    _nomsoc.clear();
                    _desc.clear();
                    _quantite.clear();
                    if (res != null) {
                      demandes[index] = res;
                      saveOffreData(res, index: index, modify: true);
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

  Future<void> deletedemandeprix(String prixId) async {
    try {
      final db = FirebaseFirestore.instance;
      final prixRef = db.collection('demandeprix').doc(prixId);

      await prixRef.delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("une erreur est survenue veuillez réessayer ultérieurement"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<Demande?> showEditDialog(BuildContext context,
      {bool modify = false, Demande? demande}) async {
    return showDialog<Demande>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify
              ? "modifier une demande d'offre"
              : "ajouter une demande d'offre"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  TextField(
                    controller: _nomsoc,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _desc,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description de Demande',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _quantite,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.storage),
                    ),
                    maxLines: null,
                  ),
                  CalendarDatePicker(
                    initialDate: date,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      date = value;
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
                String nomsociete4 = _nomsoc.text;
                String decripprix = _desc.text;
                String quantiteprix = _quantite.text;

                if (nomsociete4.isEmpty ||
                    decripprix.isEmpty ||
                    quantiteprix.isEmpty) return;

                final tmp = Demande(
                  date: date,
                  description: decripprix,
                  id: demande != null
                      ? demande.id
                      : date.toString() + Random().nextInt(1000000).toString(),
                  nomsociete: nomsociete4,
                  quantiteprix: int.parse(quantiteprix),
                );

                Navigator.pop(context, tmp);
              },
              child: Text(modify ? "modifier" : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveOffreData(Demande tmp,
      {bool modify = false, int index = -1}) async {
    try {
      await _firestore
          .collection('demandeprix')
          .doc(tmp.id)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          demandes.add(tmp);
        } else {
          if (index >= 0) {
            demandes[index] = tmp;
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

  Future<void> fetchOffreData() async {
    final docs = await _firestore.collection('demandeprix').get();
    setState(() {
      demandes =
          List<Demande>.from(docs.docs.map((e) => Demande.fromMap(e)).toList());
      updateList('');
    });
  }
}

class Demande {
  final String nomsociete;
  final String description;
  final int quantiteprix;
  final DateTime date;
  final String id;

  Demande(
      {required this.date,
      required this.nomsociete,
      required this.description,
      required this.quantiteprix,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'nomsociete': nomsociete,
      'description': description,
      'quantiteprix': quantiteprix,
      'dateprix': date.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Demande(
        date: DateTime.parse(e["dateprix"]),
        nomsociete: e["nomsociete"],
        description: e["description"],
        quantiteprix: e["quantiteprix"],
        id: e.id);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
