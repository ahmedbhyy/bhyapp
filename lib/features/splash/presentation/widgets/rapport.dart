import 'dart:io';

import 'package:bhyapp/features/splash/presentation/widgets/main_douvre.dart';
import 'package:bhyapp/features/splash/presentation/widgets/taches.dart';
import 'package:bhyapp/features/splash/presentation/widgets/autres.dart';
import 'package:bhyapp/features/splash/presentation/widgets/voyage_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'homepage.dart';

class RapportJournalier extends StatefulWidget {
  final UserLocal? user;
  const RapportJournalier({Key? key, this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RapportJournalier createState() => _RapportJournalier();
}

class _RapportJournalier extends State<RapportJournalier> {
  DateTime date = DateTime.now();
  Oeuvre mainOeuvre = Oeuvre.nil;
  String autres = '';
  Voyage transport = Voyage.nil;
  List<Job> jobs = [];
  List<Item> items = [];

  @override
  void initState() {
    _refreshmenusdata(to: date);
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 80),
          child: Center(
            child: Wrap(
              spacing: 30,
              runSpacing: 20,
              children: [
                CustomCard(
                  source: 'images/maindouvre.jpeg',
                  title: "Main D'oeuvre",
                  child: Maindoeuvre(
                      oeuvre: mainOeuvre,
                      updateremotestate: updateremoteoeuvre,
                      user: widget.user),
                ),
                CustomCard(
                  source: 'images/camion.png',
                  title: 'Transport',
                  child: Voyages(
                      transport: transport,
                      update: updateremotetransport,
                      user: widget.user),
                ),
                CustomCard(
                  source: 'images/taches2.jpg',
                  title: 'Taches',
                  child: TaskList(
                      jobs: jobs,
                      items: items,
                      updatejobs: updateremotejobs,
                      updateitems: updateremoteitems,
                      user: widget.user),
                ),
                CustomCard(
                  source: 'images/autre2.jpg',
                  title: 'Autres',
                  child: Autres(
                      autres: autres,
                      updatestate: updateremoteautres,
                      user: widget.user),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        size: Platform.isAndroid ? 24 : 45,
      ),
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
      await _refreshmenusdata(to: normalised);
      setState(() {
        date = normalised;
      });
    }
  }

  Future<void> updateremoteoeuvre(Oeuvre tmp) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(date) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);
    today.set({
      'main': {
        'matin_charge_homme': tmp.matinChargeHomme,
        'matin_femme': tmp.matinFemme,
        'matin_homme': tmp.matinHomme,
        'matin_charge_femme': tmp.matinChargeFemme,
        'midi_charge_homme': tmp.midiChargeHomme,
        'midi_femme': tmp.midiFemme,
        'midi_homme': tmp.midiHomme,
        'midi_charge_femme': tmp.midiChargeFemme,
      }
    }, SetOptions(merge: true));

    setState(() {
      mainOeuvre = tmp;
    });
  }

  Future<void> updateremoteautres(String autres) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(date) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);
    today.set({'autres': autres}, SetOptions(merge: true));
    setState(() {
      autres = autres;
    });
  }

  Future<void> updateremotetransport(Voyage tmp) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(date) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);
    today.set({
      'transport': {
        'cout': tmp.cout,
        'nombres': tmp.nombres,
      },
    }, SetOptions(merge: true));

    setState(() {
      transport = tmp;
    });
  }

  Future<void> updateremotejobs(Job tmp) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(date) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);
    jobs.add(tmp);
    today.set({
      'jobs': jobs.map((e) => Job.toMap(e)),
    }, SetOptions(merge: true));
  }

  Future<void> updateremoteitems(Item tmp) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(date) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);

    items.add(tmp);
    today.set({
      'items': items.map((e) => Item.toMap(e)),
    }, SetOptions(merge: true));
  }

  Future<void> _refreshmenusdata({required DateTime to}) async {
    final db = FirebaseFirestore.instance;
    final rapjournalier = db.collection('rapport_journalier');
    final documentname = DateFormat.yMMMd().format(to) + widget.user!.firm;
    final today = rapjournalier.doc(documentname);
    final doc = await today.get();
    final data = doc.data();
    setState(() {
      final mainMap =
          ((data?['main'] ?? Oeuvre.nilMap) as Map<String, dynamic>);
      final transportMap =
          ((data?['transport'] ?? Voyage.nilMap) as Map<String, dynamic>);
      final jobsMapList =
          List<Map<String, dynamic>>.from((data?['jobs'] ?? []) as List);
      jobs = jobsMapList.map((e) => Job.fromMap(e)).toList();
      final itemsMapList =
          List<Map<String, dynamic>>.from((data?['items'] ?? []) as List);
      items = itemsMapList.map((e) => Item.fromMap(e)).toList();

      mainOeuvre = Oeuvre.fromMap(mainMap);
      autres = (data?['autres'] ?? '');
      transport = Voyage.fromMap(transportMap);
    });
  }
}

class CustomCard extends StatelessWidget {
  final String source;
  final Widget child;
  final String title;
  const CustomCard(
      {super.key,
      required this.child,
      required this.source,
      required this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => child),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        elevation: 5,
        child: Container(
          width: 300,
          height: 280,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  source,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Oeuvre {
  final int matinFemme;
  final int matinHomme;
  final double matinChargeHomme;
  final double matinChargeFemme;
  final int midiFemme;
  final int midiHomme;
  final double midiChargeHomme;
  final double midiChargeFemme;

  static final nil = Oeuvre(
      matinHomme: 0,
      matinChargeHomme: 0.0,
      matinChargeFemme: .0,
      midiFemme: 0,
      midiHomme: 0,
      midiChargeHomme: .0,
      midiChargeFemme: .0,
      matinFemme: 0);
  static final nilMap = {
    'matin_charge_homme': .0,
    'matin_femme': 0,
    'matin_homme': 0,
    'matin_charge_femme': .0,
    'midi_charge_homme': .0,
    'midi_femme': 0,
    'midi_homme': 0,
    'midi_charge_femme': .0,
  };

  static Oeuvre fromMap(Map<String, dynamic> e) {
    return Oeuvre(
      matinChargeHomme: e['matin_charge_homme'],
      matinFemme: e['matin_femme'],
      matinHomme: e['matin_homme'],
      matinChargeFemme: e['matin_charge_femme'],
      midiChargeHomme: e['midi_charge_homme'],
      midiFemme: e['midi_femme'],
      midiHomme: e['midi_homme'],
      midiChargeFemme: e['midi_charge_femme'],
    );
  }

  Oeuvre(
      {required this.matinHomme,
      required this.matinChargeFemme,
      required this.matinChargeHomme,
      required this.midiFemme,
      required this.midiHomme,
      required this.midiChargeFemme,
      required this.midiChargeHomme,
      required this.matinFemme});
}

class Voyage {
  final int nombres;
  final double cout;

  static final nil = Voyage(nombres: 0, cout: 0);
  static final nilMap = {
    'nombres': 0,
    'cout': .0,
  };

  static Voyage fromMap(Map<String, dynamic> e) {
    return Voyage(
      cout: e['cout'],
      nombres: e['nombres'],
    );
  }

  Voyage({required this.nombres, required this.cout});
}

class Item {
  final String type;
  final String nom;
  final int qte;

  static final nil = Item(type: '', nom: '', qte: 0);
  static final nilMap = {
    'type': '',
    'nom': '',
    'qte': 0,
  };

  static Item fromMap(Map<String, dynamic> e) {
    return Item(type: e['type'], nom: e['nom'], qte: e['qte']);
  }

  static Map<String, dynamic> toMap(Item e) {
    return {'type': e.type, 'nom': e.nom, 'qte': e.qte};
  }

  Item({required this.type, required this.nom, required this.qte});
}

class Job {
  final String type;
  final String desc;
  final int qte;

  static final nil = Job(type: '', desc: '', qte: 0);
  static final nilMap = {
    'type': '',
    'desc': '',
    'qte': 0,
  };

  static Job fromMap(Map<String, dynamic> e) {
    return Job(type: e['type'], desc: e['desc'], qte: e['qte']);
  }

  static Map<String, dynamic> toMap(Job e) {
    return {'type': e.type, 'desc': e.desc, 'qte': e.qte};
  }

  Job({required this.type, required this.desc, required this.qte});
}
