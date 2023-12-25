import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FactureAdminInfo extends StatefulWidget {
  const FactureAdminInfo({super.key});

  @override
  State<FactureAdminInfo> createState() => _FactureAdminInfoState();
}

class _FactureAdminInfoState extends State<FactureAdminInfo> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime _date = DateTime.now();
  final TextEditingController _nomsoc = TextEditingController();
  final TextEditingController _numfac = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _total = TextEditingController();
  List<Facture> factures = [];
  List<Facture> displayfactureslList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displayfactureslList = List.from(factures);
      } else {
        displayfactureslList =
            factures.where((element) => element.num.contains(value)).toList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nomsoc.dispose();
    _numfac.dispose();
    _desc.dispose();
    _total.dispose();
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
                    "chercher une Facture par (N°(${displayfactureslList.length}))",
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
              itemCount: displayfactureslList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final facture = displayfactureslList[index];
                return ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(facture.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(
                      "Nom de Société: ${facture.nomsoc.toString()}\nN° Facture: ${facture.num}",
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
                                await deletefacadmin(factures[index].num);
                                setState(() {
                                  factures.removeAt(index);
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
                    _total.text = facture.total.toString();
                    _desc.text = facture.desc;
                    _numfac.text = facture.num;
                    _nomsoc.text = facture.nomsoc;
                    _date = facture.date;
                    final res = await showEditDialog(context, modify: true);
                    _total.clear();
                    _desc.clear();
                    _numfac.clear();
                    _nomsoc.clear();
                    _date = DateTime.now();
                    if (res != null) {
                      factures[index] = res;
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

  Future<void> deletefacadmin(String facadminId) async {
    try {
      final db = FirebaseFirestore.instance;
      final facadminRef = db.collection('adminfacture').doc(facadminId);

      await facadminRef.delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<Facture?> showEditDialog(BuildContext context,
      {bool modify = false}) async {
    return showDialog<Facture>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify ? "modifier la facture" : "ajouter une facture"),
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
                  TextField(
                    controller: _numfac,
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
                  TextField(
                    controller: _desc,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _total,
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
                    initialDate: _date,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _date = value;
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
                String nom = _nomsoc.text;
                String num = _numfac.text;
                String des = _desc.text;
                String tot = _total.text;

                if (tot.isEmpty || des.isEmpty || num.isEmpty || nom.isEmpty)
                  return;

                final tmp = Facture(
                    date: _date,
                    desc: des,
                    nomsoc: nom,
                    num: num,
                    total: double.parse(tot));

                Navigator.pop(context, tmp);
              },
              child: Text(modify ? "modifier" : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveData(Facture tmp,
      {bool modify = false, int index = -1}) async {
    try {
      await db
          .collection('adminfacture')
          .doc(tmp.num)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          factures.add(tmp);
        } else {
          if (index >= 0) {
            factures[index] = tmp;
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
    final docs = await db.collection('adminfacture').get();
    setState(() {
      factures =
          List<Facture>.from(docs.docs.map((e) => Facture.fromMap(e)).toList());
      updateList('');
    });
  }
}

class Facture {
  final String nomsoc;
  final String num;
  final String desc;
  final double total;
  final DateTime date;

  Facture(
      {required this.nomsoc,
      required this.num,
      required this.desc,
      required this.total,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'nomsocietefac': nomsoc,
      'numfacadmin': num,
      'descrifacadmin': desc,
      'totalfacadmin': total,
      'datefacadmin': date.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Facture(
      nomsoc: e["nomsocietefac"],
      num: e["numfacadmin"],
      desc: e["descrifacadmin"],
      total: e["totalfacadmin"],
      date: DateTime.parse(e["datefacadmin"]),
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
