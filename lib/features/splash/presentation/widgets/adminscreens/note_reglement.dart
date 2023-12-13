import 'package:flutter/material.dart';

class NoteReglement extends StatefulWidget {
  const NoteReglement({super.key});

  @override
  State<NoteReglement> createState() => _NoteReglementState();
}

class _NoteReglementState extends State<NoteReglement> {
  final TextEditingController _nomfournisseur = TextEditingController();
  final TextEditingController _numfacture = TextEditingController();
  final TextEditingController _montantfac = TextEditingController();
  final TextEditingController _modepaiment = TextEditingController();
  final TextEditingController _datedecheance = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nomfournisseur.dispose();
    _numfacture.dispose();
    _montantfac.dispose();
    _modepaiment.dispose();
    _datedecheance.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Note de Règlement",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ReglementSearch());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.green,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Nom du Fournisseur",
                controller: _nomfournisseur,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Numéro de Facture",
                controller: _numfacture,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Montant",
                controller: _montantfac,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Mode de Paiement",
                controller: _modepaiment,
              ),
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Date d'échéance",
                controller: _datedecheance,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon(
      {required String hintText, required TextEditingController controller}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showEditDialog(context, hintText, controller);
          },
        ),
      ],
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(' $hintText'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Entrer la Date',
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
                // Save the edited value
                // For example, you can update the corresponding variable or send it to a server
                // ignore: avoid_print
                print('Edited value: ${controller.text}');
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}

class ReglementSearch extends SearchDelegate {
  List<String> allData = [
    'num facture 1',
    'num facture 2',
    'num facture 3',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
