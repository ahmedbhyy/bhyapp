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
  final TextEditingController _nomdeouvrier = TextEditingController();

  TextEditingController get controller => _nomdeouvrier;
  final TextEditingController _lieudeouvrier = TextEditingController();

  TextEditingController get controller2 => _lieudeouvrier;
  @override
  void dispose() {
    _nomdeouvrier.dispose();
    _lieudeouvrier.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  List<Ouvriername> displayList = [];
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db.collection("ouvrier").get().then((qsnap) {
      setState(() {
        displayList = qsnap.docs
            .map((ouvier) =>
                Ouvriername(name: ouvier.data()["nom"], id: ouvier.id))
            .toList();
      });
    });
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      displayList = displayList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
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
            icon: const Icon(Icons.person_add),
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
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.separated(
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      displayList[index].name ?? "No Name",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hintText),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Nom et Prénom',
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: 'Lieu de Travail',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String newName = controller.text;
                if (newName.isNotEmpty) {
                  setState(() {
                    if (newName.isNotEmpty) {
                      final db = FirebaseFirestore.instance;
                      final ouvrier = db.collection("ouvrier");
                      ouvrier.add({'nom': newName}).then((value) {
                        Ouvriername newOuvrier =
                            Ouvriername(name: newName, id: value.id);
                        setState(() {
                          displayList.add(newOuvrier);
                        });
                      });
                      controller.clear();
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  print('Name cannot be empty');
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
