import 'dart:io';
import 'package:bhyapp/features/splash/presentation/widgets/quinz.dart';
import 'package:bhyapp/features/splash/presentation/widgets/quinz_money.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuinzOuvrier extends StatefulWidget {
  final Parcelle parcelle;
  const QuinzOuvrier({super.key, required this.parcelle});

  @override
  State<QuinzOuvrier> createState() => _QuinzOuvrierState();
}

class _QuinzOuvrierState extends State<QuinzOuvrier> {
  bool _isLoading = true;
  final nom = TextEditingController();
  final salairecontroller = TextEditingController();
  final search = TextEditingController();
  TextEditingController get controller => nom;


  @override
  void dispose() {
    nom.dispose();
    super.dispose();
  }

  List<Ouvrier> ouvriers = [];
  List<String> firmes = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db.collection("quinz_ouvrier").where("terre", isEqualTo: widget.parcelle.id).get().then((qsnap) {
      setState(() {
        ouvriers = qsnap.docs
            .map((ouvier) => Ouvrier(
                name: ouvier.data()["nom"],
                salaire: ouvier.data()["salaire"],
                id: ouvier.id))
            .toList();
        _isLoading = false;
      });
    });
    db.collection("firmes").get().then((val) {
      setState(() {
        firmes = val.docs.map((e) => e.id).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final souvriers = ouvriers
        .where((element) =>
        element.name.toLowerCase().contains(search.text.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 0.0,
        title: const Text(
          "Les ouvriers",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'Michroma'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () {
              String hintText = "Ajouter un Ouvrier";
              showEditDialog(context, hintText, controller);
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              TextField(
                onChanged: (value) => setState(() {}),
                controller: search,
                style: const TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    labelText: "chercher un ouvrier (${souvriers.length})",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                    )),
              ),
              const SizedBox(height: 10.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                    ))
                  : Container(),
              Expanded(
                child: ListView.separated(
                  itemCount: souvriers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      souvriers[index].name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('voir plus'),
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
                                  await deleteOuvrier(souvriers[index].id);
                                  setState(() {
                                    ouvriers.removeAt(index);
                                  });
                                },
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuinzMoney(
                            ouvrier: souvriers[index],
                            onsalchanged: (val) {
                              setState(() {
                                ouvriers[ouvriers.indexOf(souvriers[index])] = val;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> deleteOuvrier(String ouvrierId) async {
    try {
      final db = FirebaseFirestore.instance;
      final ouvrierRef = db.collection('quinz_ouvrier').doc(ouvrierId);

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

  String? selectedFirm;
  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, ss) => AlertDialog(
            title: Text(hintText),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom et Prénom',
                    ),
                  ),
                  TextField(
                    controller: salairecontroller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'salaire/Jr',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  String newName = controller.text;
                  final salaire = double.parse(salairecontroller.text);
                  if (newName.isNotEmpty) {
                    setState(() {
                      if (newName.isNotEmpty) {
                        final db = FirebaseFirestore.instance;
                        final ouvrier = db.collection("quinz_ouvrier");
                        ouvrier.add({'nom': newName, 'terre': widget.parcelle.id, "salaire": salaire}).then(
                            (value) {
                          final newOuvrier = Ouvrier(
                              name: newName, id: value.id, salaire: salaire);
                          setState(() {
                            ouvriers.add(newOuvrier);
                          });
                        });
                        controller.clear();
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Ouvrier {
  final String name;
  final String id;
  final double salaire;

  Ouvrier({required this.name, required this.id,required this.salaire});
}
