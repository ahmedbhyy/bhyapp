import 'dart:io';
import 'dart:math';
import 'package:bhyapp/features/splash/presentation/widgets/all_commandes.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/engrais_commandes2.dart';
import 'package:bhyapp/features/splash/presentation/widgets/engrais_details.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EngraisHome extends StatefulWidget {
  final UserLocal? user;
  const EngraisHome({super.key, this.user});
  @override
  State<EngraisHome> createState() => _EngraisHomeState();
}

class _EngraisHomeState extends State<EngraisHome> {
  final _nomsocietefac = TextEditingController();
  final _numfac = TextEditingController();
  bool _isLoading = true;
  @override
  void dispose() {
    super.dispose();
  }

  List<Engrai> panier = [];

  String search = "";
  List<Engrai> displayList = [];
  void updateList(String value) {
    setState(() {
      search = value;
    });
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final engrais = db.collection("engrais");
    engrais.get().then((querySnapshot) {
      setState(() {
        displayList =
            List.from(querySnapshot.docs.map((e) => Engrai.fromMap(e)));
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<Map<String, String>?> showEditDialog2(
    BuildContext context,
  ) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ajouter une commande"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  TextField(
                    controller: _nomsocietefac,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la Société',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _numfac,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'N° Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String nomsociete = _nomsocietefac.text;
                String numfacture = _numfac.text;
                if (nomsociete.isEmpty || numfacture.isEmpty) return;
                Navigator.pop(context, {
                  'nom': nomsociete,
                  'num': numfacture,
                });
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 0.0,
        title: const Text(
          "Les engrais",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'Michroma'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () {
              showEditDialog(context);
            },
          ),
          IconButton(
              icon: Icon(
                Icons.shopping_bag,
                size: Platform.isAndroid ? 24 : 45,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AllCommandes(user: widget.user!)));
              }),
          IconButton(
            icon: Badge(
              label: Text("${panier.length}"),
              backgroundColor: Colors.green.shade500,
              child: Icon(
                Icons.shopping_cart,
                size: Platform.isAndroid ? 24 : 45,
              ),
            ),
            onPressed: () async {
              final res = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => ToutsCommandes(
                      panier: panier,
                      onDelete: (engrai) {
                        setState(() {
                          panier.remove(engrai);
                        });
                      }),
                ),
              );
              if (res != null && res) {
                final data = await showEditDialog2(context);
                if (data == null) return;
                final db = FirebaseFirestore.instance;
                final comms = db.collection('commandes');
                final firm = widget.user!.firm;
                comms.add({
                  "firm": firm,
                  "nom": data["nom"],
                  "num": data["num"],
                  "panier": panier.map((e) => e.toMap()),
                  "date": DateTime.now().toString(),
                });

                for (var element in panier) {
                  final i = displayList.indexWhere((e) => e.id == element.id);
                  displayList[i] = Engrai(
                      url: element.url,
                      id: element.id,
                      priv: element.priv,
                      pria: element.pria,
                      name: element.name,
                      tva: element.tva,
                      remise: element.remise,
                      quantity:
                          max(displayList[i].quantity - element.quantity, 0));
                  db.collection("engrais").doc(element.id).set({
                    "quantity": displayList[i].quantity,
                  }, SetOptions(merge: true));
                }
                setState(() {
                  panier.clear();
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              TextField(
                onChanged: (value) => updateList(value),
                style: const TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  labelText:
                      "chercher un engrais (${displayList.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList().length})",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                    ))
                  : Container(),
              Expanded(
                child: ListView.separated(
                  itemCount: displayList
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                      .toList()
                      .length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = displayList
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList()[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: CachedNetworkImage(
                          imageUrl: item.url,
                          height: 50,
                          placeholder: (context, url) {
                            return const SizedBox(
                              height: 50,
                            );
                          }),
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
                                    await deleteengrais(item.id);
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
                      onTap: () async {
                        final res = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EngraisDetails(engrai: item, panier: panier),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            if (res["panier"]) {
                              panier.add(res["engrai"]);
                            } else {
                              displayList[displayList.indexOf(item)] =
                                  res["engrai"];
                            }
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Future<void> deleteengrais(String engraisId) async {
    try {
      final db = FirebaseFirestore.instance;
      final engraisRef = db.collection('engrais').doc(engraisId);

      await engraisRef.delete();
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

  Widget bottomSheet(String filename) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choisir la Photo de l'engrais",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Visibility(
              visible: Platform.isAndroid,
              child: TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                label: const Text("Camera"),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.remove),
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: const Text("No image"),
            ),
          ])
        ],
      ),
    );
  }

  Future<void> takePhoto(ImageSource source, String newEngraisname) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 20,
    );
    if (((pickedFile?.path) ?? '').isNotEmpty) {
      String filename = newEngraisname.replaceAll(' ', '');
      String path = pickedFile!.path;
      File file = File(path);
      final store = FirebaseStorage.instance.ref();
      final pdpref =
          store.child("engrais/$filename.${file.path.split('.').last}");
      await pdpref.putFile(file);
      path = await pdpref.getDownloadURL();
      createEngrais(path: path, newEngraisname: newEngraisname);
      return;
    }
  }

  void createEngrais(
      {String path = "https://cdn-icons-png.flaticon.com/512/1670/1670075.png",
      required String newEngraisname}) async {
    if (newEngraisname.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      final engrais = db.collection("engrais");
      Engrai tmp = Engrai(
          quantity: 0,
          priv: .0,
          pria: .0,
          tva: .0,
          remise: .0,
          name: newEngraisname,
          url: path,
          id: "");
      final doc = await engrais.add(tmp.toMap());
      tmp = Engrai(
          quantity: 0,
          priv: .0,
          pria: .0,
          tva: .0,
          remise: .0,
          name: newEngraisname,
          url: path,
          id: doc.id);
      setState(() {
        displayList.add(tmp);
      });
    }
  }

  Future<void> showEditDialog(BuildContext context) async {
    final nomdengrais = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un Engrais"),
          content: TextField(
            controller: nomdengrais,
            decoration: const InputDecoration(
              labelText: "Nom d'engrais",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String newEngraisname = nomdengrais.text;
                if (newEngraisname.isNotEmpty) {
                  Navigator.pop(context);
                  final ImageSource? source =
                      await showModalBottomSheet<ImageSource>(
                    context: context,
                    builder: (builder) {
                      return bottomSheet(newEngraisname);
                    },
                  );
                  if (source != null) {
                    await takePhoto(source, newEngraisname);
                  } else {
                    createEngrais(newEngraisname: newEngraisname);
                  }
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
