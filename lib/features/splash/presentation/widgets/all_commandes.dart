import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/engrais_commandes2.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllCommandes extends StatefulWidget {
  final UserLocal user;
  const AllCommandes({super.key, required this.user});

  @override
  State<AllCommandes> createState() => _AllCommandesState();
}

class _AllCommandesState extends State<AllCommandes> {
  List<Map<String, dynamic>> commandes = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final firm = widget.user.firm;
    Query docs = db.collection("commandes");
    if (widget.user.role != "admin") {
      docs = docs.where("firm", isEqualTo: firm);
    }
    docs.get().then((dd) {
      setState(() {
        commandes = dd.docs
            .map((e) => {
                  "nom": e["nom"],
                  "num": e["num"],
                  "id": e.id,
                  "date": DateTime.parse(e["date"]),
                  "panier": List<Map<String, dynamic>>.from(e["panier"])
                      .map((e) => Engrai.fromMap2(e))
                      .toList(),
                  "firm": e["firm"]
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
                    "total de la commande: ${panier.fold(.0, (previousValue, element) => previousValue + element.priv * element.quantity * (1 - element.remise))} DT\nNom de la Société: ${com["nom"]}",
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          PdfApi.openFile(await InvoicApi.generateFacture(
                              riadh: true,
                              items: panier
                                  .map((e) => {
                                        "quantite": e.quantity,
                                        "tva": e.tva,
                                        "remise": e.remise,
                                        "des": e.name,
                                        "montant": e.priv,
                                      })
                                  .toList(),
                              address: com["nom"],
                              client: com["nom"],
                              date: com["date"],
                              num: com["num"],
                              title: "Facture"));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Confirmer la Suppression',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              content: const Text(
                                'Vous êtes sûr ?',
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
                                    await deletecommandeeng(com['id']);
                                    setState(() {
                                      commandes.removeAt(index);
                                    });
                                  },
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  title: Text(
                      com["num"] +
                          " \n " +
                          DateFormat('yyyy-MM-dd').format(com["date"]),
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

  Future<void> deletecommandeeng(String ouvrierId) async {
    try {
      final db = FirebaseFirestore.instance;
      final ouvrierRef = db.collection('commandes').doc(ouvrierId);

      await ouvrierRef.delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("une erreur est survenue veuillez réessayer ultérieurement"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
