import 'dart:io';

import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FactureInfo extends StatefulWidget {
  final UserLocal? user;
  const FactureInfo({super.key, this.user});

  @override
  State<FactureInfo> createState() => _FactureInfoState();
}

class _FactureInfoState extends State<FactureInfo> {
  bool _isLoading = true;
  List<Facture> displayList = [];
  final search = TextEditingController();
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final factures = db.collection("factures");
    final firm = widget.user!.firm;
    factures.where("firm", isEqualTo: firm).get().then((qsnap) {
      setState(() {
        displayList = qsnap.docs.map((e) => Facture.fromMap(e)).toList();
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final display = displayList
        .where((element) => element.num.toString().contains(search.text))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Factures",
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () async {
              final res = await Navigator.push<Facture>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AjoutFacture(
                            user: widget.user!,
                          )));
              if (res != null) {
                final db = FirebaseFirestore.instance;
                final factures = db.collection("factures");
                factures.doc(res.num).set(res.toMap(), SetOptions(merge: true));
                setState(() {
                  displayList.add(res);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  labelText: "chercher une facture Par (N°(${display.length}))",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                  )),
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                ))
              : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: ListView.separated(
                  itemCount: display.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final facture = display[index];
                    return ListTile(
                      leading: Icon(
                        Icons.description,
                        color: Colors.green.shade600,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Text(
                        "Nom de la Societé : ${facture.nomsoc} \nTotal : ${facture.total} DT\nFirme: ${facture.firm}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text("Numéro du Facture: ${facture.num}"),
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
                                    await deletefacture(displayList[index].num);
                                    setState(() {
                                      displayList.removeAt(index);
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
                        final facttmp = await Navigator.push<Facture>(context,
                            MaterialPageRoute(builder: (context) {
                          return AjoutFacture(
                            facture: facture,
                            user: widget.user!,
                          );
                        }));
                        final db = FirebaseFirestore.instance;
                        if (facttmp == null) return;
                        db
                            .collection("factures")
                            .doc(facture.num)
                            .set(facttmp.toMap(), SetOptions(merge: true));
                        setState(() {
                          displayList[displayList.indexOf(facture)] = facttmp;
                        });
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deletefacture(String facId) async {
    try {
      final db = FirebaseFirestore.instance;
      final facRef = db.collection('factures').doc(facId);

      await facRef.delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement")));
    }
  }
}

class AjoutFacture extends StatefulWidget {
  final Facture? facture;
  final UserLocal user;
  const AjoutFacture({super.key, this.facture, required this.user});

  @override
  State<AjoutFacture> createState() => _AjoutFactureState();
}

class _AjoutFactureState extends State<AjoutFacture> {
  final TextEditingController _numerodufact = TextEditingController();
  final TextEditingController _totalfact = TextEditingController(text: "0");
  final TextEditingController _nomsoc = TextEditingController();
  List<Map<String, dynamic>> items = [];
  String _title = "ajouter une facture";
  DateTime _datefact = DateTime.now();

  @override
  void initState() {
    if (widget.facture != null) {
      final facture = widget.facture!;
      _numerodufact.text = facture.num.toString();
      _totalfact.text = facture.total.toString();
      _nomsoc.text = facture.nomsoc;
      items = facture.items;
      _datefact = facture.date;
      _title = "modifier la facture";
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _numerodufact.dispose();
    _totalfact.dispose();
    _nomsoc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  CalendarDatePicker(
                    initialDate: _datefact,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datefact = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                  TextField(
                    controller: _numerodufact,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'N° de la facture',
                      enabled: widget.facture == null,
                      labelStyle: const TextStyle(fontSize: 20),
                      icon: const Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  TextField(
                    controller: _totalfact,
                    decoration: const InputDecoration(
                      labelText: 'total de la facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.euro),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: Icon(
                            Icons.payments,
                            color: Colors.green.shade600,
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                          isThreeLine: true,
                          subtitle: Text(
                            item["des"],
                            style: TextStyle(color: Colors.green.shade500),
                          ),
                          title: Text(
                              (item['quantite'] * item["montant"]).toString(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          onTap: () async {
                            final tmp = await showModalBottomSheet<
                                    Map<String, dynamic>>(
                                context: context,
                                builder: (context) {
                                  return ItemAdder(
                                    item: item,
                                  );
                                });
                            if (tmp != null) {
                              setState(() {
                                items[items.indexOf(item)] = tmp;
                                _totalfact.text = items
                                    .fold(
                                        .0,
                                        (previousValue, element) =>
                                            previousValue +
                                            element['montant'] *
                                                element['quantite'])
                                    .toString();
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: FilledButton(
                  onPressed: () {
                    if (items.isEmpty ||
                        _nomsoc.text.isEmpty ||
                        _totalfact.text.isEmpty ||
                        _numerodufact.text.isEmpty) {
                      return;
                    }
                    final firm = widget.user.firm;
                    final bon = Facture(
                      items: items,
                      total: double.parse(_totalfact.text),
                      nomsoc: _nomsoc.text,
                      firm: firm,
                      num: _numerodufact.text,
                      date: _datefact,
                    );
                    Navigator.pop(context, bon);
                  },
                  child: const Text("enregistrer"),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: FilledButton.icon(
                    onPressed: () async {
                      final res =
                          await showModalBottomSheet<Map<String, dynamic>>(
                              context: context,
                              builder: (context) {
                                return const ItemAdder();
                              });
                      if (res != null) {
                        setState(() {
                          items.add(res);
                          _totalfact.text = items
                              .fold(
                                  .0,
                                  (previousValue, element) =>
                                      previousValue +
                                      element['montant'] * element['quantite'])
                              .toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.add_outlined),
                    label: const Text("ajouter")))
          ],
        ),
      ),
    );
  }
}

class ItemAdder extends StatefulWidget {
  final Map<String, dynamic>? item;
  const ItemAdder({super.key, this.item});

  @override
  State<ItemAdder> createState() => _ItemAdderState();
}

class _ItemAdderState extends State<ItemAdder> {
  final _designation = TextEditingController();
  final _quantite = TextEditingController();
  final _montant = TextEditingController();

  @override
  void initState() {
    if (widget.item != null) {
      _designation.text = widget.item!["des"];
      _quantite.text = widget.item!["quantite"].toString();
      _montant.text = widget.item!["montant"].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextField(
                  onSubmitted: (val) {},
                  controller: _designation,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("désignation"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: _quantite,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("quantité"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: _montant,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("montant"),
                    suffixText: 'DT',
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  final tmp = ({
                    "des": _designation.text,
                    "quantite": int.parse(_quantite.text),
                    "montant": double.parse(_montant.text),
                  });
                  Navigator.pop(context, tmp);
                },
                child: Center(
                    child: Text(widget.item == null ? "ajouter" : "modifier")))
          ],
        ),
      ),
    );
  }
}

class Facture {
  final String num;
  final String nomsoc;
  final double total;
  final String firm;
  final DateTime date;
  final List<Map<String, dynamic>> items;
  Facture(
      {required this.nomsoc,
      required this.total,
      required this.date,
      required this.num,
      required this.items,
      required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "nom_soc": nomsoc,
      "firm": firm,
      "total": total,
      "items": items,
      "date": date.toString(),
    };
  }

  static Facture fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Facture(
      num: e.id,
      firm: e['firm'],
      nomsoc: e['nom_soc'],
      total: e['total'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}
