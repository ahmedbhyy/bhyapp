import 'dart:io';
import 'dart:math';
import 'package:bhyapp/apis/invoice.dart';
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
              size: Platform.isAndroid ? 24 : 45,
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
                bons.doc(res.id).set(res.toMap(), SetOptions(merge: true));
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
                        DateFormat('yyyy-MM-dd').format(bon.date),
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
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              PdfApi.openFile(await InvoicApi.generateFacture2(
                                  items: bon.items,
                                  address: bon.destination,
                                  client: bon.beneficiaire,
                                  date: bon.date,
                                  num: bon.num,
                                  title: "Bon de Livraison"));
                            },
                          ),
                          IconButton(
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
                                        await deletebonliv(
                                            displayList[index].num);
                                        setState(() {
                                          displayList.removeAt(index);
                                        });
                                      },
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                ),
                              );
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

  Future<void> deletebonliv(String livId) async {
    try {
      final db = FirebaseFirestore.instance;
      final livRef = db.collection('bonlivraison').doc(livId);

      await livRef.delete();

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

  @override
  void initState() {
    if (widget.bon != null) {
      final bon = widget.bon!;
      _numerodubon.text = bon.num.toString();
      _nomdesociete.text = bon.beneficiaire;
      _destination.text = bon.destination;
      items = bon.items;
      _datebon = bon.date;
      _title = "Modifier le Bon de Livraison";
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
                    decoration: InputDecoration(
                      labelText: 'N° du bon',
                      enabled: widget.bon == null,
                      labelStyle: const TextStyle(fontSize: 20),
                      icon: const Icon(Icons.numbers),
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
                      id: _numerodubon.text +
                          Random().nextInt(10000000).toString(),
                      items: items,
                      beneficiaire: _nomdesociete.text,
                      destination: _destination.text,
                      firm: firm,
                      num: _numerodubon.text,
                      date: _datebon,
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
                    label: Text("désignation"),
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
                    label: Text("unité"),
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
                    label: Text("quantité"),
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
                    child: Text(widget.item == null ? "ajouter" : "modifier")))
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
  final String id;
  final String num;
  final String beneficiaire;
  final String destination;
  final String firm;
  final DateTime date;
  final List<Map<String, dynamic>> items;
  Bon(
      {required this.date,
      required this.num,
      required this.id,
      required this.beneficiaire,
      required this.destination,
      required this.items,
      required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "beneficiaire": beneficiaire,
      "destination": destination,
      "firm": firm,
      "items": items,
      "date": date.toString(),
      "num": num,
    };
  }

  static Bon fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Bon(
      id: e.id,
      num: e['num'],
      firm: e['firm'],
      beneficiaire: e["beneficiaire"],
      destination: e['destination'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}
