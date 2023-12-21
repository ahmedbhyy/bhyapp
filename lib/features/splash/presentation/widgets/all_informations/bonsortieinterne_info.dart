import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format_field/date_format_field.dart';
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


class AjoutBon extends StatefulWidget {
  const AjoutBon({super.key});

  @override
  State<AjoutBon> createState() => _AjoutBonState();
}

class _AjoutBonState extends State<AjoutBon> {
  final TextEditingController _numerodubon = TextEditingController();
  final TextEditingController _beneficiaire = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final List<Map<String, dynamic>> items = [];
  DateTime _datebon = DateTime.now();
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
        title: const Text(
          "ajouter un bon de sortie",
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
                      _datebon = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                  TextField(
                    controller: _numerodubon,
                    decoration: const InputDecoration(
                      labelText: 'N° du bon',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
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
                    if(_datebon == null || items.isEmpty || _beneficiaire.text.isEmpty || _destination.text.isEmpty || _numerodubon.text.isEmpty) {
                      return;
                    }
                    final firm = FirebaseAuth.instance.currentUser!.email!.split("@")[1].split('.')[0];
                    final bon = Bon(
                        items: items,
                        beneficiaire: _beneficiaire.text,
                        destination: _destination.text,
                        firm: firm,
                        num: int.parse(_numerodubon.text),
                        date: _datebon!,
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
                                        child: const Center(child: Text("ajouter")))
                                  ],
                                ),
                              ),
                            );
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


class Bon {
  final int num;
  final String beneficiaire;
  final String destination;
  final String firm;
  final DateTime date;
  final List<Map<String, dynamic>> items;
  Bon({required this.date, required this.num, required this.beneficiaire, required this.destination, required this.items, required this.firm});

  Map<String, dynamic> toMap() {
    return {
      "num": num,
      "beneficiaire": beneficiaire,
      "destination": destination,
      "firm": firm,
      "items": items,
      "date": date.toString(),
    };
  }

  static Bon fromMap(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return Bon(
      num: e["num"],
      firm: e['firm'],
      beneficiaire: e["beneficiaire"],
      destination: e['destination'],
      items: List<Map<String, dynamic>>.from(e["items"]! as List),
      date: DateTime.parse(e["date"]),
    );
  }
}