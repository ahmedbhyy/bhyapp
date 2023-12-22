import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TousCommandes extends StatefulWidget {
  final String id;
  const TousCommandes({super.key, required this.id});

  @override
  State<TousCommandes> createState() => _TousCommandesState();
}

class _TousCommandesState extends State<TousCommandes> {
  List<Map<String, dynamic>> commandes = [];
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final doc = db.collection("engrais").doc(widget.id);
    doc.get().then((value) {
      setState(() {
        commandes = List<Map<String, dynamic>>.from(
            (value.data()?["commandes"] ?? []) as List);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tous les commandes",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          final now = (commandes[index]['date'] as Timestamp).toDate();
          return ListTile(
            leading: const Icon(Icons.shopping_cart_outlined, size: 70),
            title: Text("commandes ${index + 1}"),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(now) +
                '\n${commandes[index]["desc"]}' +
                '\n${commandes[index]["prix"]}' +
                '\n${commandes[index]["quant"]}'),
          );
        },
        itemCount: commandes.length,
      ),
    );
  }
}
