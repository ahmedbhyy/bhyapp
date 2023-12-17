import 'package:bhyapp/features/splash/presentation/widgets/bon_sortie.dart';
import 'package:flutter/material.dart';

class BonSortieInfo extends StatefulWidget {
  const BonSortieInfo({super.key});

  @override
  State<BonSortieInfo> createState() => _BonSortieInfoState();
}

class _BonSortieInfoState extends State<BonSortieInfo> {
  final TextEditingController _numboninterne = TextEditingController();
  TextEditingController get controller => _numboninterne;
  final TextEditingController _numerodubon = TextEditingController();
  final TextEditingController _beneficiaire = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _quantite = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _numerodubon.dispose();
    _beneficiaire.dispose();
    _destination.dispose();
    _designation.dispose();
    _quantite.dispose();
    _numboninterne.dispose();
  }

  List<BonSortieint> mainbonList = [
    BonSortieint(
        num_bon2: "52854",
        beneficiaire_bon2: "fdff",
        destination_bon2: "jerba",
        designation_bon2: "erezez",
        quantite_bon2: "20"),
    BonSortieint(
        num_bon2: "587411",
        beneficiaire_bon2: "xsde",
        destination_bon2: "sfax",
        designation_bon2: "efzef",
        quantite_bon2: "54"),
    BonSortieint(
        num_bon2: "5298",
        beneficiaire_bon2: "xxxx",
        destination_bon2: "mestir",
        designation_bon2: "oifjeaf",
        quantite_bon2: "42"),
    BonSortieint(
        num_bon2: "54210",
        beneficiaire_bon2: "xxx",
        destination_bon2: "gabes",
        designation_bon2: "ofizaef",
        quantite_bon2: "78"),
    BonSortieint(
        num_bon2: "125496",
        beneficiaire_bon2: "éfazef",
        destination_bon2: "tunis",
        designation_bon2: "iojadigi",
        quantite_bon2: "45"),
  ];
  List<BonSortieint> displayList = [];
  @override
  void initState() {
    displayList = List.from(mainbonList);
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      displayList = mainbonList
          .where((element) => element.num_bon2.toString().contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Sorties interne",
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              String hintText = "Ajouter un Bon de Sortie";
              showEditDialog(context, hintText, controller);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => updateList(value),
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  hintText: "chercher un Bon de sortie interne",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                  )),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: displayList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                title: Text(
                  displayList[index].num_bon2 ?? "No Name",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(hintText),
            content: Column(
              children: [
                TextField(
                  controller: _numerodubon,
                  decoration: const InputDecoration(
                    labelText: 'N° du bon',
                    labelStyle: TextStyle(fontSize: 20),
                    icon: Icon(Icons.numbers),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _beneficiaire,
                  decoration: const InputDecoration(
                    labelText: 'Bénéficiaire',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _destination,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    labelStyle: TextStyle(fontSize: 20),
                    icon: Icon(Icons.place),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _designation,
                  decoration: const InputDecoration(
                    labelText: 'Désignation',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _quantite,
                  decoration: const InputDecoration(
                    labelText: 'Quantité',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 20),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BonSortieint {
  // ignore: non_constant_identifier_names
  String? num_bon2;
  // ignore: non_constant_identifier_names
  String? beneficiaire_bon2;
  // ignore: non_constant_identifier_names
  String? destination_bon2;
  // ignore: non_constant_identifier_names
  String? designation_bon2;
  // ignore: non_constant_identifier_names
  String? quantite_bon2;
  // ignore: non_constant_identifier_names
  BonSortieint(
      {this.num_bon2,
      this.beneficiaire_bon2,
      this.destination_bon2,
      this.designation_bon2,
      this.quantite_bon2});
}
