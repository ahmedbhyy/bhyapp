import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OuvrierVoyageDiesel extends StatefulWidget {
  final String id;
  const OuvrierVoyageDiesel({super.key, required this.id});

  @override
  State<OuvrierVoyageDiesel> createState() => _OuvrierVoyageDieselState();
}


class _OuvrierVoyageDieselState extends State<OuvrierVoyageDiesel> {
  final descController = TextEditingController();
  final dieselController = TextEditingController();
  List<Voyage> voyages = [];
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
        voyages = List<Map<String, dynamic>>.from((doc.data()?["voyages"] ?? []) as List).map((e) => Voyage(description: e['desc'], diesel: e['diesel'], date: DateTime.parse(e['date']))).toList();
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
          final res = await showModalBottomSheet<Voyage>(
            context: context,
            builder: (context) {
              return _generateBottomSheet(context);
            },
            showDragHandle: true,
            scrollControlDisabledMaxHeightRatio: .8,
          );
          if(res != null) {
            final db = FirebaseFirestore.instance;
            final ouvrier = db.collection("ouvrier").doc(widget.id);
            setState(() {
              voyages.add(res);
              ouvrier.update({
                "voyages": voyages.map((e) => {
                  "diesel": e.diesel,
                  "desc": e.description,
                  "date": e.date.toString()
                })
              });
            });
          }
        },
        child: const Icon(Icons.add),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "Voyages et diesel",
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
              itemCount: voyages.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index)  {
                final voyage = voyages[index];
                return ListTile(
                  leading: Icon(Icons.local_gas_station_outlined, color: Colors.green.shade600,),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text("${DateFormat('yyyy-MM-dd').format(voyage.date)} | ${voyage.diesel}L", style: TextStyle(color: Colors.green.shade500),),
                  title: Text("${voyage.description}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  onTap: () {

                  },
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
                  onSubmitted: (val) {
      
                  },
                  controller: descController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.card_travel_outlined),
                    label: Text("description du voyage"),
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  onSubmitted: (val) {
      
                  },
                  controller: dieselController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_gas_station_outlined),
                    label: Text("quantité du diesel"),
                  ),
                ),
                const SizedBox(height: 20,),
                CalendarDatePicker(
                  initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 366)),
                  lastDate: DateTime.now().add(const Duration(days: 366)),
                  onDateChanged: (DateTime value) {
                    date = value;
                  },
                  currentDate: DateTime.now(),
                ),
                const SizedBox(height: 50,)
              ],
            ),
            FilledButton(
                onPressed: () {
                  final tmp = Voyage(description: descController.text, date: date, diesel: double.parse(dieselController.text));
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Ajouter un voyage")))
          ],
        ),
      ),
    );
  }
}

class Voyage {
  final double diesel;
  final DateTime date;
  final String description;

  Voyage({required this.diesel, required this.date, required this.description});
}