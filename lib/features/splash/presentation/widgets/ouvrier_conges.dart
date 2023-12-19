import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CongesOuvrier extends StatefulWidget {
  final String id;
  const CongesOuvrier({super.key, required this.id});

  @override
  State<CongesOuvrier> createState() => _CongesOuvrierState();
}

class _CongesOuvrierState extends State<CongesOuvrier> {
  final controller = TextEditingController(text: "120");
  List<Conges> conges = [];
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
        conges = List<Map<String, dynamic>>.from(
                (doc.data()?["conges"] ?? []) as List)
            .map((e) =>
                Conges(cause: e['cause'], date: DateTime.parse(e['date'])))
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
          final res = await showModalBottomSheet<Conges>(
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
              conges.add(res);
              ouvrier.update({
                "conges": conges
                    .map((e) => {"cause": e.cause, "date": e.date.toString()})
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "congés",
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
              itemCount: conges.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final cong = conges[index];
                return ListTile(
                  leading: Icon(
                    Icons.sick_outlined,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(cong.date),
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(cong.cause,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sick),
                    label: Text("cause du congés"),
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
                  final tmp = Conges(cause: controller.text, date: date);
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter un congés")))
          ],
        ),
      ),
    );
  }
}

class Conges {
  final String cause;
  final DateTime date;

  Conges({required this.cause, required this.date});
}
