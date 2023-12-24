import 'package:bhyapp/features/splash/presentation/widgets/all_informations/engrais_commandes2.dart';
import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllCommandes extends StatefulWidget {
  const AllCommandes({super.key});

  @override
  State<AllCommandes> createState() => _AllCommandesState();
}

class _AllCommandesState extends State<AllCommandes> {
  List<Map<String, dynamic>> commandes = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      final firm = value.data()!["lieu de travail"];
      final docs =
          await db.collection("commandes").where("firm", isEqualTo: firm).get();
      setState(() {
        commandes = docs.docs
            .map((e) => {
                  "date": DateTime.parse(e["date"]),
                  "panier": List<Map<String, dynamic>>.from(e["panier"])
                      .map((e) => Engrai.fromMap2(e))
                      .toList(),
                })
            .toList();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: commandes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final com = commandes[index];
                final List<Engrai> panier = com["panier"];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ToutsCommandes(
                                panier: panier, date: com["date"])));
                  },
                  leading: Icon(
                    Icons.payments,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    "total de la commande: ${panier.fold(.0, (previousValue, element) => previousValue + element.priv * element.quantity)}",
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(DateFormat('yyyy-MM-dd').format(com["date"]),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
