import 'package:bhyapp/features/splash/presentation/widgets/quinz_ouvrier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuinzMoney extends StatefulWidget {
  final Ouvrier ouvrier;
  final void Function(Ouvrier) onsalchanged;
  const QuinzMoney(
      {super.key, required this.ouvrier, required this.onsalchanged});

  @override
  State<QuinzMoney> createState() => _QuinzMoneyState();
}

class _QuinzMoneyState extends State<QuinzMoney> {
  final controller = TextEditingController();
  final saljour = TextEditingController();
  List<Prime> primes = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    saljour.text = widget.ouvrier.salaire.toString();
    db
        .collection("quinz_money")
        .where("ouvrier", isEqualTo: widget.ouvrier.id)
        .get()
        .then((doc) async {
      setState(() {
        primes = doc.docs
            .map((e) => Prime(
                montant: e['montant'],
                date: (e['date'] as Timestamp).toDate(),
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
            final ouvrier = await db.collection("quinz_money").add({
              "montant": res.montant,
              "date": res.date,
              "ouvrier": widget.ouvrier.id
            });
            setState(() {
              primes.add(
                  Prime(montant: res.montant, date: res.date, id: ouvrier.id));
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "Les Transports",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: saljour,
                    style: const TextStyle(fontSize: 17.0),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        labelText: "Salaire /Jr",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xFFC2BCBC)),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                FilledButton(
                  child: const Text("enregistrer"),
                  onPressed: () {
                    final db = FirebaseFirestore.instance;
                    db
                        .collection("quinz_ouvrier")
                        .doc(widget.ouvrier.id)
                        .update({"salaire": double.parse(saljour.text)});
                    widget.onsalchanged(Ouvrier(
                        name: widget.ouvrier.name,
                        id: widget.ouvrier.name,
                        salaire: double.parse(saljour.text)));
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: primes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final prime = primes[index];
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
      final ref = db.collection('quinz_money').doc(primes[index].id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        primes.removeAt(index);
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
                    label: Text("quantité"),
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
                  final tmp = Prime(
                      montant: double.parse(controller.text),
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

class Prime {
  final double montant;
  final DateTime date;
  final String id;

  Prime({required this.montant, required this.date, required this.id});
}
