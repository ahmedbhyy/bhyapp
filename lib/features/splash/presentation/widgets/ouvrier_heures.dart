import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OuvrierHeure extends StatefulWidget {
  final String id;
  const OuvrierHeure({super.key, required this.id});

  @override
  State<OuvrierHeure> createState() => _OuvrierHeureState();
}

class _OuvrierHeureState extends State<OuvrierHeure> {
  final controller = TextEditingController();
  List<SupHour> supp = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final ouvrier = db.collection("ouvrier").doc(widget.id);
    ouvrier.get().then((doc) {
      setState(() {
        supp = List<Map<String, dynamic>>.from(
                (doc.data()?["heures_sup"] ?? []) as List)
            .map((e) => SupHour(num: e['num'], date: DateTime.parse(e['date'])))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final res = await showModalBottomSheet<SupHour>(
            context: context,
            builder: (context) {
              return _generateBottomSheet(context);
            },
            showDragHandle: true,
            scrollControlDisabledMaxHeightRatio: .8,
          );
          if (res != null) {
            final db = FirebaseFirestore.instance;
            final ouvrier = db.collection("ouvrier").doc(widget.id);
            setState(() {
              supp.add(res);
              ouvrier.update({
                "heures_sup":
                    supp.map((e) => {"num": e.num, "date": e.date.toString()})
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "Heures supplémentaire",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: supp.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final hsup = supp[index];
                return ListTile(
                  leading: Icon(
                    Icons.timer_outlined,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(hsup.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text('${hsup.num.toString()} H',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  onTap: () {},
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
                                await deleteitem(index);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteitem(int index) async {
    try {
      final db = FirebaseFirestore.instance;
      final ref = db.collection('ouvrier').doc(widget.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        supp.removeAt(index);
        ref.update({
          "heures_sup":
              supp.map((e) => {"num": e.num, "date": e.date.toString()})
        });
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "une erreur est survenue veuillez réessayer ultérieurement"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _generateBottomSheet(BuildContext context) {
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
                    prefixIcon: Icon(Icons.timer_outlined),
                    label: Text("Nombres d'heures"),
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
                  final tmp =
                      SupHour(num: double.parse(controller.text), date: date);
                  Navigator.pop(context, tmp);
                },
                child:
                    const Center(child: Text("ajouter heures supplémentaire")))
          ],
        ),
      ),
    );
  }
}

class SupHour {
  final double num;
  final DateTime date;

  SupHour({required this.num, required this.date});
}
