import 'dart:io';

import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FactureInfo extends StatefulWidget {
  final UserLocal? user;
  final bool? admin;
  const FactureInfo({super.key, this.user, this.admin});

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
    Query<Map<String, dynamic>> factures = db.collection("factures");
    final firm = widget.user!.firm;
    if (widget.admin != null) {
      factures = db.collection("adminfacture");
    } else {
      if (widget.user!.role != "admin") {
        factures = factures.where("firm", isEqualTo: firm);
      }
    }
    factures.get().then((qsnap) {
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
        title: Text(
          "Les Factures ${widget.admin != null ? 'administratives' : ''}",
          style: const TextStyle(
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
              size: Platform.isAndroid ? 24 : 55,
            ),
            onPressed: () async {
              final res = await Navigator.push<Facture>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AjoutFacture(
                            user: widget.user!,
                            admin: widget.admin,
                          )));
              if (res != null) {
                final db = FirebaseFirestore.instance;
                final factures = widget.admin == null
                    ? db.collection("factures")
                    : db.collection("adminfacture");
                await factures
                    .doc(res.id)
                    .set(res.toMap(), SetOptions(merge: true));
                final field = widget.admin != null && widget.admin!
                    ? 'nextadmin'
                    : 'next';
                db
                    .collection('metadata')
                    .doc('facture')
                    .update({field: res.num + 1});
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
                        "Nom de la Societé : ${facture.nomsoc} \nTotal : ${facture.total} DT\nFerme: ${facture.firm}\nCreer Par : ${facture.creerpar} le ${Utils.formatDate(facture.date)}\n${facture.modifierpar.isEmpty ? '' : 'Modifier Par : ${facture.modifierpar} le ${Utils.formatDate(facture.datemodif)}'}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text("Numéro du Facture: ${facture.num}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.green,
                              size: Platform.isAndroid ? 24 : 50,
                            ),
                            onPressed: () async {
                              PdfApi.openFile(await InvoicApi.generateFacture(
                                  items: facture.items,
                                  address: facture.nomsoc,
                                  client: facture.nomsoc,
                                  date: facture.date,
                                  num: Utils.factNum(facture),
                                  title: "Facture"));
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        final facttmp = await Navigator.push<Facture>(context,
                            MaterialPageRoute(builder: (context) {
                          return AjoutFacture(
                            facture: facture,
                            admin: widget.admin,
                            user: widget.user!,
                          );
                        }));
                        final db = FirebaseFirestore.instance;
                        if (facttmp == null) return;
                        (widget.admin == null
                                ? db.collection("factures")
                                : db.collection("adminfacture"))
                            .doc(facture.id)
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
}

class AjoutFacture extends StatefulWidget {
  final Facture? facture;
  final bool? admin;
  final UserLocal user;
  const AjoutFacture({super.key, this.facture, required this.user, this.admin});

  @override
  State<AjoutFacture> createState() => _AjoutFactureState();
}

class _AjoutFactureState extends State<AjoutFacture> {
  final TextEditingController _numerodufact = TextEditingController();
  final TextEditingController _totalfact = TextEditingController(text: "0");
  final TextEditingController _nomsoc = TextEditingController();
  List<Map<String, dynamic>> items = [];
  String _title = "Ajouter une facture";
  DateTime _datefact = DateTime.now();
  int num = 0;

  @override
  void initState() {
    final field = widget.admin != null && widget.admin! ? 'nextadmin' : 'next';
    if (widget.facture != null) {
      final facture = widget.facture!;
      _numerodufact.text = Utils.factNum(facture);
      _totalfact.text = facture.total.toString();
      _nomsoc.text = facture.nomsoc;
      items = facture.items;
      _datefact = facture.date;
      _title = "Modifier la facture";
    } else {
      final db = FirebaseFirestore.instance;
      db.collection('metadata').doc('facture').get().then((factureMeta) {
        setState(() {
          _numerodufact.text = Utils.intFixed(factureMeta.data()![field]) +
              '/' +
              DateTime.now().year.toString();
          num = factureMeta.data()![field];
        });
      });
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'N° de la facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
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
                    keyboardType: TextInputType.number,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Total de la facture ',
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
                    final creerpar = widget.facture != null
                        ? widget.facture!.creerpar
                        : widget.user.name;
                    final modifierpar =
                        widget.facture != null ? widget.user.name : '';
                    final date = widget.facture != null
                        ? widget.facture!.date
                        : _datefact;
                    final _num =
                        widget.facture != null ? widget.facture!.num : num;
                    final bon = Facture(
                      modifierpar: modifierpar,
                      creerpar: creerpar,
                      items: items,
                      total: double.parse(_totalfact.text),
                      nomsoc: _nomsoc.text,
                      firm: firm,
                      num: _num,
                      date: date,
                      datemodif: DateTime.now(),
                    );
                    Navigator.pop(context, bon);
                  },
                  child: const Text("Enregistrer"),
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
                    label: const Text("Ajouter")))
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
  final _remise = TextEditingController();
  final _tvafacture = TextEditingController(text: '19');

  @override
  void initState() {
    if (widget.item != null) {
      _designation.text = widget.item!["des"];
      _quantite.text = widget.item!["quantite"].toString();
      _montant.text = widget.item!["montant"].toString();
      _tvafacture.text = widget.item!["tva"].toString();
      _remise.text = (widget.item!["remise"] * 100).toString();
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
                    label: Text("Désignation"),
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
                    label: Text("Quantité"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: _tvafacture,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("%TVA"),
                    suffixText: '%',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (a) => onclick(),
                  controller: _montant,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Montant"),
                    suffixText: 'DT',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (a) => onclick(),
                  controller: _remise,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Remise %"),
                    suffixText: '%',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            FilledButton(
                onPressed: onclick,
                child: Center(
                    child: Text(widget.item == null ? "Ajouter" : "Modifier")))
          ],
        ),
      ),
    );
  }

  onclick() {
    final tmp = ({
      "des": _designation.text,
      "quantite": int.parse(_quantite.text),
      "tva": int.parse(_tvafacture.text),
      "montant": double.parse(_montant.text),
      "remise": double.parse(_remise.text) / 100,
    });
    Navigator.pop(context, tmp);
  }
}

class Facture {
  final String modifierpar;
  final String creerpar;
  final int num;
  final String nomsoc;
  final double total;
  final String firm;
  final DateTime date;
  final DateTime datemodif;
  final List<Map<String, dynamic>> items;
  String get id => num.toString() + date.year.toString();
  Facture(
      {required this.nomsoc,
      this.modifierpar = "",
      required this.total,
      required this.date,
      required this.datemodif,
      required this.creerpar,
      required this.num,
      required this.items,
      required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "modifierpar": modifierpar,
      "num": num,
      "datemodif": datemodif.toString(),
      "creerpar": creerpar,
      "nom_soc": nomsoc,
      "firm": firm,
      "total": total,
      "items": items,
      "date": date.toString(),
    };
  }

  static Facture fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Facture(
      modifierpar: e["modifierpar"],
      num: e["num"],
      firm: e['firm'],
      datemodif: DateTime.parse(e["datemodif"]),
      creerpar: e['creerpar'],
      nomsoc: e['nom_soc'],
      total: e['total'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}
