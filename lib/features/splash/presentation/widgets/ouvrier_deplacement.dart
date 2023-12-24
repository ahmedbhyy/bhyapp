import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OuvrierDeplacement extends StatefulWidget {
  final String id;
  const OuvrierDeplacement({super.key, required this.id});

  @override
  State<OuvrierDeplacement> createState() => _OuvrierDeplacementState();
}

class _OuvrierDeplacementState extends State<OuvrierDeplacement> {
  final controller = TextEditingController();
  List<Deplacement> deps = [];
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
        deps =
            List<Map<String, dynamic>>.from((doc.data()?["deps"] ?? []) as List)
                .map((e) => Deplacement(
                    description: e['desc'], date: DateTime.parse(e['date'])))
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
          final res = await showModalBottomSheet<Deplacement>(
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
              deps.add(res);
              ouvrier.update({
                "deps": deps.map(
                    (e) => {"desc": e.description, "date": e.date.toString()})
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "Déplacement",
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
              itemCount: deps.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final cong = deps[index];
                return ListTile(
                  leading: Icon(
                    Icons.work_outline,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(cong.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(cong.description,
                      style:
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
      setState(() {
        deps.removeAt(index);
        ref.update({
          "deps": deps.map(
                  (e) => {"desc": e.description, "date": e.date.toString()})
        });
      });
    } catch(e) {}
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
                  controller: controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_outline),
                    label: Text("description du déplacement"),
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
                      Deplacement(description: controller.text, date: date);
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter un déplacement")))
          ],
        ),
      ),
    );
  }
}

class Deplacement {
  final String description;
  final DateTime date;

  Deplacement({required this.description, required this.date});
}
