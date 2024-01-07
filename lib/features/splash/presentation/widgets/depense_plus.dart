import 'package:bhyapp/features/splash/presentation/widgets/depense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepenseViewer extends StatefulWidget {
  final Depense depense;
  const DepenseViewer(
      {super.key, required this.depense});

  @override
  State<DepenseViewer> createState() => _DepenseViewerState();
}

class _DepenseViewerState extends State<DepenseViewer> {
  final controller = TextEditingController();
  final firmcontroller = TextEditingController();
  List<DepItem> depenses = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db
        .collection("depense").doc(widget.depense.name).collection("items")
        .get()
        .then((doc) async {
      setState(() {
        depenses = doc.docs
            .map((e) => DepItem(
                quantity: e['montant'],
                date: (e['date'] as Timestamp).toDate(),
                firme: e['firme'],
                id: e.id))
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
          final res = await showModalBottomSheet<DepItem>(
            context: context,
            builder: (context) {
              return _generateBottomSheet(context);
            },
            showDragHandle: true,
            scrollControlDisabledMaxHeightRatio: .8,
          );
          if (res != null) {
            final db = FirebaseFirestore.instance;
            final ouvrier = await db.collection("depense").doc(widget.depense.name).collection('items').add({
              "montant": res.quantity,
              "date": res.date,
              "firme": res.firme,
            });
            setState(() {
              depenses.add(
                  DepItem(quantity: res.quantity, date: res.date, id: ouvrier.id, firme: res.firme));
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text(
          "Les Depenses: ${widget.depense.name}",
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: depenses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prime = depenses[index];
                return ListTile(
                  leading: Icon(
                    Icons.person_outlined,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(prime.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(prime.quantity.toString(),
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
      final ref = db.collection('depense').doc(widget.depense.name).collection("items").doc(depenses[index].id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        depenses.removeAt(index);
        ref.delete();
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("une erreur est survenue veuillez réessayer ultérieurement"),
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
                    //prefixIcon: Icon(Icons.),
                    label: Text("montant"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: firmcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    //prefixIcon: Icon(Icons.),
                    label: Text("Ferme"),
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
                  final tmp = DepItem(
                      quantity: double.parse(controller.text),
                      firme: firmcontroller.text,
                      date: date,
                      id: "");
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter")))
          ],
        ),
      ),
    );
  }
}

class DepItem {
  final double quantity;
  final DateTime date;
  final String firme;
  final String id;

  DepItem({required this.quantity, required this.date, required this.id, required this.firme});
}
