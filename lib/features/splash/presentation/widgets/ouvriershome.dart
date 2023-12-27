import 'dart:io';

import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_details.dart';
import 'package:bhyapp/ouvrier/ouvrier_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OuvrierHome extends StatefulWidget {
  const OuvrierHome({super.key});

  @override
  State<OuvrierHome> createState() => _OuvrierHomeState();
}

class _OuvrierHomeState extends State<OuvrierHome> {
  bool _isLoading = true;
  final TextEditingController _nomdeouvrier = TextEditingController();
  TextEditingController get controller => _nomdeouvrier;

  @override
  void dispose() {
    _nomdeouvrier.dispose();
    super.dispose();
  }

  List<Ouvriername> displayList = [];
  List<Ouvriername> originalList = [];
  List<String> firmes = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db.collection("ouvrier").get().then((qsnap) {
      setState(() {
        originalList = qsnap.docs
            .map((ouvier) => Ouvriername(
                name: ouvier.data()["nom"],
                lieu: ouvier.data()["lieu"],
                id: ouvier.id))
            .toList();
        displayList = List.from(originalList);
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

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displayList = List.from(originalList);
      } else {
        displayList = originalList
            .where((element) =>
                element.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) => updateList(value),
                style: const TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    labelText: "chercher un ouvrier (${displayList.length})",
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
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      displayList[index].name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Lieu de travail : ${displayList[index].lieu}',
                      style: TextStyle(
                        color: displayList[index].lieu != null
                            ? Colors.green
                            : Colors.grey,
                        fontSize: displayList[index].lieu != null ? 16 : 14,
                      ),
                    ),
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
                                  await deleteOuvrier(displayList[index].id);
                                  setState(() {
                                    displayList.removeAt(index);
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
                          builder: (context) => OuvrierDetails(
                            Ouvriername: displayList[index].name,
                            id: displayList[index].id,
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
      final ouvrierRef = db.collection('ouvrier').doc(ouvrierId);

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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    value: selectedFirm,
                    hint: const Text('Lieu de Travail'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFirm = newValue;
                        ss(() {});
                      });
                    },
                    items: firmes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  String newName = controller.text;
                  String newlieu = selectedFirm ?? "tunis";
                  if (newName.isNotEmpty) {
                    setState(() {
                      if (newName.isNotEmpty) {
                        final db = FirebaseFirestore.instance;
                        final ouvrier = db.collection("ouvrier");
                        ouvrier.add({'nom': newName, 'lieu': newlieu}).then(
                            (value) {
                          Ouvriername newOuvrier = Ouvriername(
                              name: newName, lieu: newlieu, id: value.id);
                          setState(() {
                            displayList.add(newOuvrier);
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
