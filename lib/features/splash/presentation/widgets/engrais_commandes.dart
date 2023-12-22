import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'all_informations/engrais_commandes.dart';

class Commandes extends StatefulWidget {
  final String id;
  const Commandes({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Commandes createState() => _Commandes();
}

class _Commandes extends State<Commandes> {
  List<String> descriptionFields3 = [];
  TextEditingController _prixcontroller = TextEditingController();
  TextEditingController _quantcontroller = TextEditingController();
  TextEditingController _desccontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Ajouter une Commandes",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Michroma',
              color: Colors.green,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildTextFieldWithEditIcon(
                  hintText: "Prix de vente", controller: _prixcontroller),
              const SizedBox(
                height: 10,
              ),
              buildTextFieldWithEditIcon(
                  hintText: "quantité", controller: _quantcontroller),
              const SizedBox(
                height: 10,
              ),
              buildTextFieldWithEditIcon(
                  hintText: "description de la commande",
                  controller: _desccontroller),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final db = FirebaseFirestore.instance;
                    final doc = db.collection("engrais").doc(widget.id);
                    doc.get().then((value) async {
                      final commandes = List<Map<String, dynamic>>.from(
                          (value.data()?["commandes"] ?? []) as List);
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      commandes.add({
                        'prix': double.parse(_prixcontroller.text),
                        'quant': int.parse(_quantcontroller.text),
                        'desc': _desccontroller.text,
                        'date': picked
                      });

                      await doc.update({'commandes': commandes});

                      _desccontroller.text = '';
                      _prixcontroller.text = '';
                      _quantcontroller.text = '';
                    });
                  },
                  child: const Text('Ajouter une commande'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 350, left: 300),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TousCommandes(
                          id: widget.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.storage,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildTextFieldWithEditIcon(
      {required String hintText,
      required TextEditingController controller,
      TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 20.0),
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
          ),
        ),
      ),
    );
  }
}
