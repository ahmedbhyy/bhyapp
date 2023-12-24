import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BonLivraisonInfo extends StatefulWidget {
  const BonLivraisonInfo({super.key});

  @override
  State<BonLivraisonInfo> createState() => _BonLivraisonInfoState();
}

class _BonLivraisonInfoState extends State<BonLivraisonInfo> {
  final TextEditingController _nnn1 = TextEditingController();
  TextEditingController get controller => _nnn1;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime _datebonliv = DateTime.now();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _numbonliv = TextEditingController();
  final TextEditingController _descrip = TextEditingController();
  final TextEditingController _total = TextEditingController();
  List<Bon> bons = [];
  List<Bon> displaynoteslList = [];

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displaynoteslList = List.from(bons);
      } else {
        displaynoteslList =
            bons.where((element) => element.numbonliv.contains(value)).toList();
      }
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

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
            onPressed: () async {
              final data = await showEditDialog(context);
              if (data != null) {
                saveData(data);
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.green,
              size: Platform.isAndroid ? 30 : 45,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (_) => updateList(_),
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
          Expanded(
            child: ListView.separated(
              itemCount: displaynoteslList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final bon = displaynoteslList[index];
                return ListTile(
                  leading: Icon(
                    Icons.payments,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(bon.dateliv),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(
                      "Nom Société : ${bon.nomsocieteliv.toString()}\nN° Bon: ${bon.numbonliv}",
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
                                await deletebonliv(bons[index].numbonliv);
                                setState(() {
                                  bons.removeAt(index);
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
                    _total.text = bon.totalliv.toString();
                    _descrip.text = bon.descripliv;
                    _numbonliv.text = bon.numbonliv;
                    _nomdesociete.text = bon.nomsocieteliv;
                    _datebonliv = bon.dateliv;
                    final res = await showEditDialog(context, modify: true);
                    _total.clear();
                    _descrip.clear();
                    _numbonliv.clear();
                    _nomdesociete.clear();
                    _datebonliv = DateTime.now();
                    if (res != null) {
                      bons[index] = res;
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

  Future<void> deletebonliv(String livId) async {
    try {
      final db = FirebaseFirestore.instance;
      final livRef = db.collection('bonlivraison').doc(livId);

      await livRef.delete();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement")));
    }
  }

  Future<Bon?> showEditDialog(BuildContext context,
      {bool modify = false}) async {
    return showDialog<Bon>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(modify
              ? "modifier un Bon de Livraison"
              : "Ajouter un Bon de Livraison"),
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
                    enabled: !modify,
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
                String nom = _nomdesociete.text;
                String num = _numbonliv.text;
                String des = _descrip.text;
                String tot = _total.text;

                if (tot.isEmpty || des.isEmpty || num.isEmpty || nom.isEmpty)
                  return;

                final tmp = Bon(
                  dateliv: _datebonliv,
                  descripliv: des,
                  nomsocieteliv: nom,
                  numbonliv: num,
                  totalliv: double.parse(tot),
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

  Future<void> saveData(Bon tmp, {bool modify = false, int index = -1}) async {
    try {
      await db
          .collection('bonlivraison')
          .doc(tmp.numbonliv)
          .set(tmp.toMap(), SetOptions(merge: true));
      setState(() {
        if (!modify) {
          bons.add(tmp);
        } else {
          if (index >= 0) {
            bons[index] = tmp;
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
    final docs = await db.collection('bonlivraison').get();
    setState(() {
      bons = List<Bon>.from(docs.docs.map((e) => Bon.fromMap(e)).toList());
      updateList('');
    });
  }
}

class Bon {
  final String nomsocieteliv;
  final String numbonliv;
  final String descripliv;
  final double totalliv;
  final DateTime dateliv;

  Bon(
      {required this.dateliv,
      required this.descripliv,
      required this.nomsocieteliv,
      required this.numbonliv,
      required this.totalliv});

  Map<String, dynamic> toMap() {
    return {
      'nomsocieteliv': nomsocieteliv,
      'numbonliv': numbonliv,
      'descripliv': descripliv,
      'totalliv': totalliv,
      'dateliv': dateliv.toString(),
    };
  }

  static fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Bon(
      nomsocieteliv: e["nomsocieteliv"],
      numbonliv: e["numbonliv"],
      descripliv: e["descripliv"],
      totalliv: e["totalliv"],
      dateliv: DateTime.parse(e["dateliv"]),
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
