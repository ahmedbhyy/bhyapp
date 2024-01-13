import 'dart:io';
import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BonLivraisonInfo2 extends StatefulWidget {
  final UserLocal? user;
  const BonLivraisonInfo2({super.key, this.user});

  @override
  State<BonLivraisonInfo2> createState() => _BonLivraisonInfo2State();
}

class _BonLivraisonInfo2State extends State<BonLivraisonInfo2> {
  bool _isLoading = true;
  List<Bon> displayList = [];
  final search = TextEditingController();
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> bons = db.collection("bonlivraison");
    final firm = widget.user!.firm;
    if (widget.user!.role != "admin") {
      bons = bons.where("firm", isEqualTo: firm);
    }
    bons.get().then((qsnap) {
      setState(() {
        displayList = qsnap.docs.map((e) => Bon.fromMap(e)).toList();
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
          "Les Bons de Livraison",
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
              size: Platform.isAndroid ? 24 : 55,
            ),
            onPressed: () async {
              final res = await Navigator.push<Bon>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AjoutBonLiv(
                            user: widget.user!,
                          )));
              if (res != null) {
                final db = FirebaseFirestore.instance;
                final bons = db.collection("bonlivraison");
                await bons.doc(res.id).set(res.toMap(), SetOptions(merge: true));
                db.collection('metadata').doc('bon_liv').update({'next': res.num+1});
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
                  labelText:
                      "chercher un Bon de Livraison Par N°(${display.length})",
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
                    final bon = display[index];
                    return ListTile(
                      leading: Icon(
                        Icons.local_shipping,
                        color: Colors.green.shade600,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Text(
                        '${DateFormat('yyyy-MM-dd').format(bon.date)}\nCreer Par : ${bon.creerpar} le ${Utils.formatDate(bon.date)}\n${bon.modifierpar.isEmpty ? '' : 'Modifier Par : ${bon.modifierpar} le ${Utils.formatDate(bon.datemodif)}'}',
                        style: TextStyle(color: Colors.green.shade500),
                      ),
                      title: Text(
                          "Nom Société : ${bon.beneficiaire.toString()}\nN° Bon: ${bon.num}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
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
                              PdfApi.openFile(await InvoicApi.generateFacture2(
                                  items: bon.items,
                                  address: bon.destination,
                                  client: bon.beneficiaire,
                                  date: bon.date,
                                  num: Utils.factNum(bon.toFacture()),
                                  title: "Bon de Livraison"));
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        final bn = await Navigator.push<Bon>(context,
                            MaterialPageRoute(builder: (context) {
                          return AjoutBonLiv(
                            bon: bon,
                            user: widget.user!,
                          );
                        }));
                        final db = FirebaseFirestore.instance;
                        if (bn == null) return;
                        db
                            .collection("bonlivraison")
                            .doc(bon.id)
                            .set(bn.toMap(), SetOptions(merge: true));
                        setState(() {
                          displayList[displayList.indexOf(bon)] = bn;
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

class AjoutBonLiv extends StatefulWidget {
  final Bon? bon;
  final UserLocal user;
  const AjoutBonLiv({super.key, this.bon, required this.user});

  @override
  State<AjoutBonLiv> createState() => _AjoutBonLivState();
}

class _AjoutBonLivState extends State<AjoutBonLiv> {
  final TextEditingController _numerodubon = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  List<Map<String, dynamic>> items = [];
  String _title = "Ajouter un bon de Livraison";
  DateTime _datebon = DateTime.now();
  int num = 0;


  @override
  void initState() {
    if (widget.bon != null) {
      final bon = widget.bon!;
      _numerodubon.text = Utils.factNum(bon.toFacture());
      _nomdesociete.text = bon.beneficiaire;
      _destination.text = bon.destination;
      items = bon.items;
      _datebon = bon.date;
      _title = "Modifier le Bon de Livraison";
    } else {
      final db =FirebaseFirestore.instance;
      db.collection('metadata').doc('bon_liv').get().then((bonMeta) {
        setState(() {
          const field = 'next';
          _numerodubon.text = Utils.intFixed(bonMeta.data()![field]) + '/' + DateTime.now().year.toString();
          num = bonMeta.data()![field];
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _numerodubon.dispose();
    _nomdesociete.dispose();
    _destination.dispose();
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
                    initialDate: _datebon,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datebon = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                  TextFormField(
                    controller: _numerodubon,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'N° du bon',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nomdesociete,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la Société',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _destination,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.place),
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
                          title: Text(item['quantite'].toString(),
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
                        _nomdesociete.text.isEmpty ||
                        _destination.text.isEmpty ||
                        _numerodubon.text.isEmpty) {
                      return;
                    }
                    final firm = widget.user.firm;
                    final bon = Bon(
                      modifierpar: widget.bon != null ? widget.user.name : "",
                      creerpar: widget.bon != null ? widget.bon!.creerpar : widget.user.name,
                      datemodif: DateTime.now(),
                      items: items,
                      beneficiaire: _nomdesociete.text,
                      destination: _destination.text,
                      firm: firm,
                      num: widget.bon != null ? widget.bon!.num : num,
                      date: widget.bon != null ? widget.bon!.date : _datebon,
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
  final _tva = TextEditingController(text: "19");
  final _unit = TextEditingController();

  @override
  void initState() {
    if (widget.item != null) {
      _designation.text = widget.item!["des"];
      _tva.text = (widget.item!['tva'] * 100).toString();
      _unit.text = (widget.item!['unit']).toString();
      _quantite.text = widget.item!["quantite"].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Column(
              children: [
                TextField(
                  onSubmitted: (val) {},
                  controller: _designation,
                  textInputAction: TextInputAction.next,
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
                  controller: _tva,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("%TVA"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: _unit,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Unité"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (a) => onclick(),
                  controller: _quantite,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Quantité"),
                  ),
                ),
                const SizedBox(
                  height: 15,
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
      "tva": double.parse(_tva.text) / 100,
      "unit": double.parse(_unit.text),
    });
    Navigator.pop(context, tmp);
  }
}

class Bon {
  final String modifierpar;
  final String creerpar;
  final int num;
  final String beneficiaire;
  final String destination;
  final String firm;
  final DateTime date;
  final DateTime datemodif;
  final List<Map<String, dynamic>> items;
    String get id => "$num${date.year}";
  Bon(
      {required this.date,
      this.modifierpar = "",
      required this.num,
      required this.creerpar,
      required this.datemodif,
      required this.beneficiaire,
      required this.destination,
      required this.items,
      required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "modifierpar": modifierpar,
      "creerpar": creerpar,
      "beneficiaire": beneficiaire,
      "destination": destination,
      "firm": firm,
      "items": items,
      "date": date.toString(),
      "datemodif": datemodif.toString(),
      "num": num,
    };
  }

  static Bon fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Bon(
      modifierpar: e["modifierpar"],
      creerpar: e['creerpar'],
      datemodif: DateTime.parse(e["datemodif"]),
      num: e['num'],
      firm: e['firm'],
      beneficiaire: e["beneficiaire"],
      destination: e['destination'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
  Facture toFacture() => Facture(nomsoc: "", total: 0, date: date, datemodif: datemodif, creerpar: creerpar, num: num, items: items, firm: firm);
}
