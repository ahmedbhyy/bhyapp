import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FactureInfo extends StatefulWidget {
  const FactureInfo({super.key});

  @override
  State<FactureInfo> createState() => _FactureInfoState();
}

class _FactureInfoState extends State<FactureInfo> {
  List<Facture> displayList = [];
  final search = TextEditingController();
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final factures = db.collection("factures");
    final firm = FirebaseAuth.instance.currentUser!.email!.split("@")[1].split('.')[0];
    factures.where("firm", isEqualTo: firm).get().then((qsnap) {
      setState(() {
        displayList = qsnap.docs.map((e) => Facture.fromMap(e)).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.add),
            onPressed: () async {
              final res = await Navigator.push<Facture>(context, MaterialPageRoute(builder: (context) => const AjoutFacture()));
              if(res != null) {
                final db = FirebaseFirestore.instance;
                final bons = db.collection("factures");
                bons.add(res.toMap());
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
                setState(() {

                });
              },
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  labelText: "chercher une facture Par (N°)",
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
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.separated(
                  itemCount: displayList
                      .where((element) => element.num.toString().contains(search.text))
                      .toList().length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final list = displayList
                        .where((element) => element.num.toString().contains(search.text))
                        .toList();
                    final facture = list[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Text(
                        "à ${facture.nom_soc} | ${facture.total}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text("facture numéro ${facture.num}"),
                      onTap: () {},
                    );
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AjoutFacture extends StatefulWidget {
  const AjoutFacture({super.key});

  @override
  State<AjoutFacture> createState() => _AjoutFactureState();
}

class _AjoutFactureState extends State<AjoutFacture> {
  final TextEditingController _numerodufact = TextEditingController();
  final TextEditingController _totalfact = TextEditingController(text: "0");
  final TextEditingController _nomsoc = TextEditingController();
  final List<Map<String, dynamic>> items = [];
  DateTime _datefact = DateTime.now();
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
        title: const Text(
          "ajouter une facture",
          style: TextStyle(
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
              child: Column(
                children: [
                  CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datefact = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                  TextField(
                    controller: _numerodufact,
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
                          title: Text((item['quantite'] * item["montant"]).toString(),
                              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          onTap: () {},
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
                    if(items.isEmpty || _nomsoc.text.isEmpty || _totalfact.text.isEmpty || _numerodufact.text.isEmpty) {
                      return;
                    }
                    final firm = FirebaseAuth.instance.currentUser!.email!.split("@")[1].split('.')[0];
                    final bon = Facture(
                      items: items,
                      total: double.parse(_totalfact.text),
                      nom_soc: _nomsoc.text,
                      firm: firm,
                      num: int.parse(_numerodufact.text),
                      date: _datefact,
                    );
                    Navigator.pop(context, bon);
                  },
                  child: const Text("enregistrer"),
                )
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child:  FilledButton.icon(
                    onPressed: () async {
                      final _designation = TextEditingController();
                      final _quantite = TextEditingController();
                      final _montant = TextEditingController();
                      final res = await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          builder: (context) {
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
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text("montant"),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                        child: const Center(child: Text("ajouter")))
                                  ],
                                ),
                              ),
                            );
                          });
                      if(res != null) {
                        setState(() {
                          items.add(res);
                          _totalfact.text = items.fold(.0, (previousValue, element) => previousValue + element['montant']*element['quantite']).toString();
                        });
                        print(res);
                      }
                    },
                    icon: const Icon(Icons.add_outlined), label: const Text("ajouter"))
            )
          ],
        ),
      ),
    );
  }
}


class Facture {
  final int num;
  final String nom_soc;
  final double total;
  final String firm;
  final DateTime date;
  final List<Map<String, dynamic>> items;
  Facture({required this.nom_soc, required this.total, required this.date, required this.num, required this.items, required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "num": num,
      "nom_soc": nom_soc,
      "firm": firm,
      "total": total,
      "items": items,
      "date": date.toString(),
    };
  }

  static Facture fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Facture(
      num: e["num"],
      firm: e['firm'],
      nom_soc: e['nom_soc'],
      total: e['total'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}
//items.fold(.0, (previousValue, element) => previousValue + element['montant'])