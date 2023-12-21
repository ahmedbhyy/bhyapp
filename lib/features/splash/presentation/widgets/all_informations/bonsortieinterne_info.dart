import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BonSortieInfo extends StatefulWidget {
  const BonSortieInfo({super.key});

  @override
  State<BonSortieInfo> createState() => _BonSortieInfoState();
}

class _BonSortieInfoState extends State<BonSortieInfo> {
  List<Bon> displayList = [];
  final search = TextEditingController();
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final bons = db.collection("bons");
    final firm = FirebaseAuth.instance.currentUser!.email!.split("@")[1].split('.')[0];
    bons.where("firm", isEqualTo: firm).get().then((qsnap) {
      setState(() {
        displayList = qsnap.docs.map((e) => Bon.fromMap(e)).toList();
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
          "Les Bons de Sorties interne",
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
              final res = await Navigator.push<Bon>(context, MaterialPageRoute(builder: (context) => AjoutBon()));
              if(res != null) {
                final db = FirebaseFirestore.instance;
                final bons = db.collection("bons");
                bons.doc(res.num).set(res.toMap(), SetOptions(merge: true));
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
                  labelText: "chercher un Bon de sortie interne",
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
                  final bon = list[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    subtitle: Text(
                      "à ${bon.destination} | ${bon.beneficiaire}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text("Bon numéro ${bon.num}"),
                    onTap: () async{
                      final bn = await Navigator.push<Bon>(context, MaterialPageRoute(builder: (context) {
                        return AjoutBon(bon:bon);
                      }));
                      final db = FirebaseFirestore.instance;
                      if (bn == null) return;
                      db.collection("bons").doc(bon.num).set(bn.toMap(), SetOptions(merge: true));
                      setState(() {
                        displayList[displayList.indexOf(bon)] = bn;
                      });
                    },
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


class AjoutBon extends StatefulWidget {
  final Bon? bon;
  const AjoutBon({super.key, this.bon});

  @override
  State<AjoutBon> createState() => _AjoutBonState();
}

class _AjoutBonState extends State<AjoutBon> {
  final TextEditingController _numerodubon = TextEditingController();
  final TextEditingController _beneficiaire = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  List<Map<String, dynamic>> items = [];
  String _title = "ajouter un bon de sortie";
  DateTime _datebon = DateTime.now();

  @override
  void initState() {
    if(widget.bon != null) {
      final bon = widget.bon!;
      _numerodubon.text = bon.num.toString();
      _beneficiaire.text = bon.beneficiaire;
      _destination.text = bon.destination;
      items = bon.items;
      _datebon = bon.date;
      _title = "modifier le bon de sortie";
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _numerodubon.dispose();
    _beneficiaire.dispose();
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
              child: Column(
                children: [
                  CalendarDatePicker(
                    initialDate: _datebon,
                    firstDate: DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      _datebon = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                  TextField(
                    controller: _numerodubon,
                    decoration: InputDecoration(
                      labelText: 'N° du bon',
                      enabled: widget.bon == null,
                      labelStyle: const TextStyle(fontSize: 20),
                      icon: const Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _beneficiaire,
                    decoration: const InputDecoration(
                      labelText: 'Bénéficiaire',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _destination,
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
                              style:
                              const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          onTap: () async {
                              final tmp = await showModalBottomSheet<Map<String, dynamic>>(context: context, builder: (context) {
                                return ItemAdder(item: item,);
                              });
                              if(tmp != null) {
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
                    if(items.isEmpty || _beneficiaire.text.isEmpty || _destination.text.isEmpty || _numerodubon.text.isEmpty) {
                      return;
                    }
                    final firm = FirebaseAuth.instance.currentUser!.email!.split("@")[1].split('.')[0];
                    final bon = Bon(
                        items: items,
                        beneficiaire: _beneficiaire.text,
                        destination: _destination.text,
                        firm: firm,
                        num: _numerodubon.text,
                        date: _datebon,
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
                      final res = await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          builder: (context) {
                            return ItemAdder();
                          });
                      if(res != null) {
                        setState(() {
                          items.add(res);
                        });
                        print(res);
                      }
                    },
                    icon: Icon(Icons.add_outlined), label: Text("ajouter"))
            )
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

  @override
  void initState() {
    if(widget.item != null) {
      _designation.text = widget.item!["des"];
      _quantite.text = widget.item!["quantite"].toString();
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
              ],
            ),
            FilledButton(
                onPressed: () {
                  final tmp = ({
                    "des": _designation.text,
                    "quantite": int.parse(_quantite.text)
                  });
                  Navigator.pop(context, tmp);
                },
                child: Center(child: Text(widget.item == null ? "ajouter": "modifier")))
          ],
        ),
      ),
    );
  }
}



class Bon {
  final String num;
  final String beneficiaire;
  final String destination;
  final String firm;
  final DateTime date;
  final List<Map<String, dynamic>> items;
  Bon({required this.date, required this.num, required this.beneficiaire, required this.destination, required this.items, required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "beneficiaire": beneficiaire,
      "destination": destination,
      "firm": firm,
      "items": items,
      "date": date.toString(),
    };
  }

  static Bon fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Bon(
      num: e.id,
      firm: e['firm'],
      beneficiaire: e["beneficiaire"],
      destination: e['destination'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}