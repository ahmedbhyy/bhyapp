import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OuvrierPrime extends StatefulWidget {
  final String id;
  const OuvrierPrime({super.key, required this.id});

  @override
  State<OuvrierPrime> createState() => _OuvrierPrimeState();
}

class _OuvrierPrimeState extends State<OuvrierPrime> {
  final controller = TextEditingController();
  List<Prime> primes = [];
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
        primes = List<Map<String, dynamic>>.from(
                (doc.data()?["primes"] ?? []) as List)
            .map((e) =>
                Prime(montant: e['montant'], date: DateTime.parse(e['date'])))
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
          final res = await showModalBottomSheet<Prime>(
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
              primes.add(res);
              ouvrier.update({
                "primes": primes.map(
                    (e) => {"montant": e.montant, "date": e.date.toString()})
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "primes",
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
              itemCount: primes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prime = primes[index];
                return ListTile(
                  leading: Icon(
                    Icons.payments,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(prime.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(prime.montant.toString(),
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
      setState(() {
        primes.removeAt(index);
        ref.update({
          "primes": primes.map(
                  (e) => {"montant": e.montant, "date": e.date.toString()})
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
                  onSubmitted: (val) {},
                  controller: controller,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.euro),
                    suffixText: 'DT',
                    label: Text("montant de la prime"),
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
                      Prime(montant: double.parse(controller.text), date: date);
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter une prime")))
          ],
        ),
      ),
    );
  }
}

class Prime {
  final double montant;
  final DateTime date;

  Prime({required this.montant, required this.date});
}
