import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DevisInfo extends StatefulWidget {
  const DevisInfo({super.key});

  @override
  State<DevisInfo> createState() => _DevisInfoState();
}

class _DevisInfoState extends State<DevisInfo> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime _datedeviss = DateTime.now();
  final TextEditingController _nomdesociete3 = TextEditingController();
  final TextEditingController _numdevisadmin = TextEditingController();
  final TextEditingController _descridevisadmin = TextEditingController();
  final TextEditingController _totaldevisadmin = TextEditingController();
  List<Devi> devis = [];
  List<Devi> displaydevislList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displaydevislList = List.from(devis);
      } else {
        displaydevislList =
            devis.where((element) => element.numdevis.contains(value)).toList();
      }
    });
  }

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
                    "chercher un Devis par (N°(${displaydevislList.length}))",
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
              itemCount: displaydevislList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final devi = displaydevislList[index];
                return ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(devi.datedevis),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(
                      "Nom de Société: ${devi.nomsocietedevis.toString()}\nN° Devis: ${devi.numdevis}",
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
                                await deletedevis(devis[index].numdevis);
                                setState(() {
                                  devis.removeAt(index);
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
                    _totaldevisadmin.text = devi.totaldevis.toString();
                    _descridevisadmin.text = devi.descridevis;
                    _numdevisadmin.text = devi.numdevis;
                    _nomdesociete3.text = devi.nomsocietedevis;
                    _datedeviss = devi.datedevis;
                    final res = await showEditDialog(context, modify: true);
                    _totaldevisadmin.clear();
                    _descridevisadmin.clear();
                    _numdevisadmin.clear();
                    _nomdesociete3.clear();
                    _datedeviss = DateTime.now();
                    if (res != null) {
                      devis[index] = res;
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

  Future<void> deletedevis(String devisId) async {
    try {
      final db = FirebaseFirestore.instance;
      final devisRef = db.collection('devis').doc(devisId);

      await devisRef.delete();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement")));
    }
  }

  Future<Devi?> showEditDialog(BuildContext context,
      {bool modify = false}) async {
    return showDialog<Devi>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify ? "modifier un devis" : "ajouter un devis"),
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
                    enabled: !modify,
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
                String nom = _nomdesociete3.text;
                String num = _numdevisadmin.text;
                String des = _descridevisadmin.text;
                String tot = _totaldevisadmin.text;

                if (tot.isEmpty || des.isEmpty || num.isEmpty || nom.isEmpty)
                  return;

                final tmp = Devi(
                    datedevis: _datedeviss,
                    descridevis: des,
                    nomsocietedevis: nom,
                    numdevis: num,
                    totaldevis: double.parse(tot));

                Navigator.pop(context, tmp);
              },
              child: Text(modify ? "modifier" : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveData(Devi tmp, {bool modify = false, int index = -1}) async {
    try {
      await db
          .collection('devis')
          .doc(tmp.numdevis)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          devis.add(tmp);
        } else {
          if (index >= 0) {
            devis[index] = tmp;
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
    final docs = await db.collection('devis').get();
    setState(() {
      devis = List<Devi>.from(docs.docs.map((e) => Devi.fromMap(e)).toList());
      updateList('');
    });
  }
}

class Devi {
  final String nomsocietedevis;
  final String numdevis;
  final String descridevis;
  final double totaldevis;
  final DateTime datedevis;

  Devi(
      {required this.nomsocietedevis,
      required this.numdevis,
      required this.descridevis,
      required this.totaldevis,
      required this.datedevis});

  Map<String, dynamic> toMap() {
    return {
      'nomsocietedevis': nomsocietedevis,
      'numdevis': numdevis,
      'descridevis': descridevis,
      'totaldevis': totaldevis,
      'datedevis': datedevis.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Devi(
      nomsocietedevis: e["nomsocietedevis"],
      numdevis: e["numdevis"],
      descridevis: e["descridevis"],
      totaldevis: e["totaldevis"],
      datedevis: DateTime.parse(e["datedevis"]),
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
