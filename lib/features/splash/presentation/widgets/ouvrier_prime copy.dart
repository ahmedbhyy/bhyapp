import 'dart:io';

import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Habatadetails2 extends StatefulWidget {
  final String Ouvriername;
  final String id;
  final UserLocal user;
  const Habatadetails2(
      {super.key,
      required this.id,
      required this.Ouvriername,
      required this.user});

  @override
  State<Habatadetails2> createState() => _Habatadetails2State();
}

class _Habatadetails2State extends State<Habatadetails2> {
  final controller = TextEditingController();
  List<Habat> habata = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final ouvrier = db.collection("habata").doc(widget.id);
    ouvrier.get().then((doc) {
      setState(() {
        habata = List<Map<String, dynamic>>.from(
                (doc.data()?["primes"] ?? []) as List)
            .map((e) => Habat(
                quantite: e['quantite'],
                date: DateTime.parse(e['date']),
                nom: e["user"]))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.Ouvriername} \n (${habata.fold(0, (previousValue, element) => previousValue + element.quantite)} Lames)",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: Platform.isAndroid ? 24 : 60,
            ),
            onPressed: () async {
              final res = await showModalBottomSheet<Habat>(
                context: context,
                builder: (context) {
                  return _generateBottomSheet(context, add: true);
                },
                showDragHandle: true,
                scrollControlDisabledMaxHeightRatio: .8,
              );
              if (res != null) {
                final db = FirebaseFirestore.instance;
                final ouvrier = db.collection("habata").doc(widget.id);
                setState(() {
                  habata.add(res);
                  ouvrier.update({
                    "primes": habata.map((e) => {
                          "quantite": e.quantite,
                          "date": e.date.toString(),
                          "user": e.nom
                        })
                  });
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.remove,
              size: Platform.isAndroid ? 24 : 60,
            ),
            onPressed: () async {
              final res = await showModalBottomSheet<Habat>(
                context: context,
                builder: (context) {
                  return _generateBottomSheet(context, add: false);
                },
                showDragHandle: true,
                scrollControlDisabledMaxHeightRatio: .8,
              );
              if (res != null) {
                final db = FirebaseFirestore.instance;
                final ouvrier = db.collection("habata").doc(widget.id);
                setState(() {
                  habata.add(res);
                  ouvrier.update({
                    "primes": habata.map((e) => {
                          "quantite": e.quantite,
                          "date": e.date.toString(),
                          "user": e.nom,
                        })
                  });
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: habata.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prime = habata[index];
                return ListTile(
                  leading: Icon(
                    Icons.widgets,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    "${DateFormat('yyyy-MM-dd').format(prime.date)} | ${prime.nom}",
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text('${prime.quantite.toString()} Lames ',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateBottomSheet(BuildContext context, {required bool add}) {
    DateTime date = DateTime.now();
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
                  controller: controller,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.widgets),
                    label: Text("Quantités"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 366)),
                  lastDate: DateTime.now().add(const Duration(days: 366)),
                  onDateChanged: (DateTime value) {
                    date = value;
                  },
                  currentDate: DateTime.now(),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
            FilledButton(
                onPressed: () {
                  final tmp = Habat(
                      quantite: add
                          ? int.parse(controller.text)
                          : -int.parse(controller.text),
                      date: date,
                      nom: widget.user.name);
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter la Quantité")))
          ],
        ),
      ),
    );
  }
}

class Habat {
  final int quantite;
  final DateTime date;
  final String nom;

  Habat({required this.quantite, required this.date, required this.nom});
}
