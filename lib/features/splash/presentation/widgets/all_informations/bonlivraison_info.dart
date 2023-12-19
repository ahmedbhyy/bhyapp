import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class BonLivraisonInfo extends StatefulWidget {
  const BonLivraisonInfo({super.key});

  @override
  State<BonLivraisonInfo> createState() => _BonLivraisonInfoState();
}

class _BonLivraisonInfoState extends State<BonLivraisonInfo> {
  final TextEditingController _nnn1 = TextEditingController();
  TextEditingController get controller => _nnn1;
  TextEditingController _datebonliv = TextEditingController();
  final TextEditingController _nomdesociete = TextEditingController();
  final TextEditingController _numbonliv = TextEditingController();
  final TextEditingController _descrip = TextEditingController();
  final TextEditingController _total = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _datebonliv.dispose();
    _nomdesociete.dispose();
    _numbonliv.dispose();
    _descrip.dispose();
    _total.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Livraison",
          style: TextStyle(
            fontSize: 19.8,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter un Bon de Livraison";
              showEditDialog(context, hintText, controller);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.green,
              size: 35,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                labelText: "chercher un Bon Livraison par (N°)",
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
        return AlertDialog(
          title: Text(hintText),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Column(
                children: [
                  DateFormatField(
                    type: DateFormatType.type2,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      label: Text("Date du Bon"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        _datebonliv = date as TextEditingController;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nomdesociete,
                    decoration: const InputDecoration(
                        labelText: 'Nom de la société',
                        labelStyle: TextStyle(fontSize: 20),
                        icon: Icon(Icons.work)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numbonliv,
                    decoration: const InputDecoration(
                        labelText: 'N° du Bon',
                        labelStyle: TextStyle(fontSize: 20),
                        icon: Icon(Icons.numbers)),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descrip,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _total,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.euro),
                      suffixText: 'DT',
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
              onPressed: () {},
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
