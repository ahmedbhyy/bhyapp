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
  String path =
      "https://www.alpack.ie/wp-content/uploads/1970/01/MULTIBOX2-scaled.jpg";
  final TextEditingController _nomdengrais = TextEditingController();
  TextEditingController get controller => _nomdengrais;
  @override
  void dispose() {
    _nomdengrais.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  static List<Engraisname> main_engrais_list = [];
  // ignore: non_constant_identifier_names
  List<Engraisname> display_list = List.from(main_engrais_list);
  void updateList(String value) {
    setState(() {
      display_list = display_list
          .where((element) =>
              element.engrais_name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    print("aaaaaa${widget.date}");
    final db = FirebaseFirestore.instance;
    final engrais = db.collection("engrais");
    engrais.get().then((querySnapshot) {
      print("Successrully completed");
      print("${querySnapshot.size}");
      if (querySnapshot.size == 0) {
        setState(() {
          display_list = [];
        });
        return;
      }
      setState(() {
        display_list = List.from(querySnapshot.docs.map((engrais) =>
            Engraisname(
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
              String hintText = "Ajouter un Engrais";
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
                    hintText: "chercher un engrais",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                    )),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.separated(
                  itemCount: display_list.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      display_list[index].engrais_name ?? "No Name",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading:
                        Image.network(display_list[index].engrais_poster_url),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EngraisDetails(
                            engraisName: display_list[index].engrais_name,
                            id: display_list[index].id,
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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
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
                takePhoto(ImageSource.camera, filename);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, filename);
              },
              label: const Text("Gallery"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.remove),
              onPressed: () {},
              label: const Text("No image"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source, String filename) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (((pickedFile?.path) ?? '').isEmpty) return;

    final path = pickedFile!.path;
    File file = File(path);
    final store = FirebaseStorage.instance.ref();
    store
        .child("engrais/${filename}.${file.path.split('.').last}")
        .putFile(file);
    store.putFile(file);
  }

  Future<void> showEditDialog(
    BuildContext context,
    String hintText,
    TextEditingController controller,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hintText),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Nom d'engrais",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String newEngraisname = controller.text;
                if (newEngraisname.isNotEmpty) {
                  await showModalBottomSheet(
                    context: context,
                    builder: ((builder) =>
                        bottomSheet(newEngraisname.replaceAll(' ', ''))),
                  );
                  setState(() {
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
                          display_list.add(Engraisname(
                              engrais_name: doc.data()?["name"],
                              engrais_poster_url: doc.data()?["image"],
                              id: doc.id));
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
        );
      },
    );
  }
}
