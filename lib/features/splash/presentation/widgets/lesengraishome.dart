import 'dart:io';
import 'package:bhyapp/features/splash/presentation/widgets/engrais_details.dart';
import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EngraisHome extends StatefulWidget {
  final DateTime date;
  const EngraisHome({super.key, required this.date});
  @override
  State<EngraisHome> createState() => _EngraisHomeState();
}

class _EngraisHomeState extends State<EngraisHome> {
  @override
  void dispose() {
    super.dispose();
  }

  List<Engraisname> displayList = [];
  void updateList(String value) {
    setState(() {
      displayList = displayList
          .where((element) =>
              element.engrais_name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final engrais = db.collection("engrais");
    engrais.get().then((querySnapshot) {
      print("${querySnapshot.size} items");
      setState(() {
        displayList = List.from(querySnapshot.docs.map((engrais) => Engraisname(
            id: engrais.id,
            engrais_name: engrais.data()["name"],
            engrais_poster_url: engrais.data()["image"])));
      });
    });
    super.initState();
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
            icon: const Icon(Icons.add),
            onPressed: () {
              showEditDialog(context);
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
                  hintText: "chercher un engrais",
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
              Expanded(
                child: ListView.separated(
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      displayList[index].engrais_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading:
                        Image.network(displayList[index].engrais_poster_url),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EngraisDetails(
                            engraisName: displayList[index].engrais_name,
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

  Widget bottomSheet(String filename) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              label: const Text("Camera"),
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
      required String newEngraisname}) {
    if (newEngraisname.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      final engrais = db.collection("engrais");
      engrais.add({
        'name': newEngraisname,
        'image': path,
      }).then((value) async {
        print('added engrais $value');
        final doc = await value.get();
        setState(() {
          displayList.add(Engraisname(
              engrais_name: doc.data()?["name"],
              engrais_poster_url: doc.data()?["image"],
              id: doc.id));
        });
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
              hintText: "Nom d'engrais",
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
