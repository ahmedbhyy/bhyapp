import 'package:bhyapp/features/splash/presentation/widgets/main_douvre.dart';
import 'package:bhyapp/features/splash/presentation/widgets/taches.dart';
import 'package:bhyapp/features/splash/presentation/widgets/autres.dart';
import 'package:bhyapp/features/splash/presentation/widgets/voyage_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RapportJournalier extends StatefulWidget {
  const RapportJournalier({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RapportJournalier createState() => _RapportJournalier();
}

class _RapportJournalier extends State<RapportJournalier> {
  DateTime date = DateTime.now();
  Oeuvre main_oeuvre = Oeuvre.nil;

  @override
  void initState() {
    _refreshmenusdata(to:date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "rapport journalier",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: [
          _buildDatePickerIconButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Maindoeuvre(oeuvre: main_oeuvre, updateremotestate: updateremoteoeuvre,)),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/maindoeuvre.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Main D'oeuvre",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Voyages()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/transport.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Transport',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Taches()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/tache.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Taches',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Autres()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/autre.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Autres',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      var normalised = picked.copyWith(hour: 0, minute: 0, millisecond: 0);
      await _refreshmenusdata(to:normalised);
      setState(() {
        date = normalised;
      });
    }
  }

  Future<void> updateremoteoeuvre(Oeuvre tmp) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final today = rapjournalier.doc(date.toString());
    final doc = await today.get();

  }

  Future<void> _refreshmenusdata({required DateTime to}) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final today = rapjournalier.doc(to.toString());
    final doc = await today.get();
    setState(() {
      main_oeuvre  = (doc.data()?['main'] ?? Oeuvre.nil_map).map((e) => Oeuvre(
        matin_charge_homme: e['matin_charge_homme'],
        matin_femme: e['matin_femme'],
        matin_homme: e['matin_homme'],
        matin_charge_femme: e['matin_charge_femme'],
        midi_charge_homme: e['midi_charge_homme'],
        midi_femme: e['matin_femme'],
        midi_homme: e['matin_homme'],
        midi_charge_femme: e['midi_charge_femme'],
      ));
    });


  }
}

class Oeuvre {
  final int matin_femme;
  final int matin_homme;
  final double matin_charge_homme;
  final double matin_charge_femme;
  final int midi_femme;
  final int midi_homme;
  final double midi_charge_homme;
  final double midi_charge_femme;

  static final nil = Oeuvre(matin_homme: 0, matin_charge_homme: 0, matin_charge_femme: 0, midi_femme: 0, midi_homme: 0, midi_charge_homme: 0, midi_charge_femme: 0, matin_femme: 0 );
  static final nil_map = {
    'matin_charge_homme': 0,
    'matin_femme': 0,
    'matin_homme': 0,
    'matin_charge_femme': 0,
    'midi_charge_homme': 0,
    'midi_femme': 0,
    'midi_homme': 0,
    'midi_charge_femme': 0,
  };


  Oeuvre({ required this.matin_homme, required this.matin_charge_femme, required this.matin_charge_homme, required this.midi_femme, required this.midi_homme, required this.midi_charge_femme, required this.midi_charge_homme, required this.matin_femme});
}