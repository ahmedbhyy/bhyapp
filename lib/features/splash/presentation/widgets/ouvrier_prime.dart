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
        primes = List<Map<String, dynamic>>.from((doc.data()?["primes"] ?? []) as List).map((e) => Prime(montant: e['montant'], date: DateTime.parse(e['date']))).toList();
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
            if(res != null) {
              final db = FirebaseFirestore.instance;
              final ouvrier = db.collection("ouvrier").doc(widget.id);
              setState(() {
                primes.add(res);
                ouvrier.update({
                  "primes": primes.map((e) => {
                    "montant": e.montant,
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
              itemBuilder: (context, index)  {
                final prime = primes[index];
                return ListTile(
                  leading: Icon(Icons.payments, color: Colors.green.shade600,),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(prime.date), style: TextStyle(color: Colors.green.shade500),),
                  title: Text(prime.montant.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
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
    final controller = TextEditingController(text: "120");
    DateTime date = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              TextField(
                onSubmitted: (val) {
                    
                },
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.euro),
                  label: Text("montant de la prime"),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 366)),
                    lastDate: DateTime.now().add(const Duration(days: 366)),
                    onDateChanged: (DateTime value) {
                      date = value;
                    },
                    currentDate: DateTime.now(),
                  ),
                ),
              )
            ],
          ),
          FilledButton(
              onPressed: () {
                final tmp = Prime(montant: double.parse(controller.text), date: date);
                Navigator.pop(context, tmp);
              }, 
              child: const Center(child: Text("Ajouter une prime")))
        ],
      ),
    );
  }
}

class Prime {
  final double montant;
  final DateTime date;

  Prime({required this.montant, required this.date});
}