import 'package:bhyapp/features/splash/presentation/widgets/engrais_details.dart';
import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EngraisHome extends StatefulWidget {
  final DateTime date;
  const EngraisHome({super.key, required this.date});
  @override
  State<EngraisHome> createState() => _EngraisHomeState();
}

class _EngraisHomeState extends State<EngraisHome> {
  final TextEditingController _nomdengrais = TextEditingController();
  TextEditingController get controller => _nomdengrais;
  @override
  void dispose() {
    _nomdengrais.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  static List<Engraisname> main_engrais_list = [];
  /*static List<Engraisname> main_engrais_list = [
    Engraisname(
        engrais_name: "Ultra Classic 45",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/ultra-classic-45.png"),
    Engraisname(
        engrais_name: "Ultra Plus 45",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/ultra-plus-45.png"),
    Engraisname(
        engrais_name: "Ultra-Solution D.R.C Irrigation",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/Ultra-Solution-D.R.C-Irrigation.png"),
    Engraisname(
        engrais_name: "Ultra DRC Foliar TDS",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/Ultra-DRC-Foliar-TDS.png"),
    Engraisname(
        engrais_name: "ANIMAX",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/ANIMAX.png"),
    Engraisname(
        engrais_name: "Actiphol",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/cropped-actiphol2.png"),
    Engraisname(
        engrais_name: "Rhizocote",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/rhizocote-2.png"),
    Engraisname(
        engrais_name: "Power Set",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/cropped-power-set-2.png"),
    Engraisname(
        engrais_name: "Clustflo",
        engrais_poster_url:
            "https://riadhagricolemaster.tn/wp-content/uploads/2023/03/cropped-clustflo-2.png"),
  ];*/
  // ignore: non_constant_identifier_names
  List<Engraisname> display_list = List.from(main_engrais_list);
  void updateList(String value) {
    setState(() {
      display_list = main_engrais_list
          .where((element) =>
              element.engrais_name!.toLowerCase().contains(value.toLowerCase()))
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
                        Image.network(display_list[index].engrais_poster_url!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EngraisDetails(
                            engraisName: display_list[index].engrais_name!,
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
              onPressed: () {
                String newEngraisname = controller.text;
                if (newEngraisname.isNotEmpty) {
                  setState(() {
                    Engraisname newEngrais = Engraisname(engrais_name: newEngraisname, engrais_poster_url: "https://www.alpack.ie/wp-content/uploads/1970/01/MULTIBOX2-scaled.jpg");
                    if (newEngraisname.isNotEmpty) {
                      final db = FirebaseFirestore.instance;
                      final engrais = db.collection("engrais");
                      engrais.add({
                        'name': newEngrais.engrais_name,
                        'image': newEngrais.engrais_poster_url,
                      }).then((value) => print('added engrais $value'));
                      setState(() {
                        display_list.add(newEngrais);
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
