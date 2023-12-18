import 'package:flutter/material.dart';

class NoteReglementInfo extends StatefulWidget {
  const NoteReglementInfo({super.key});

  @override
  State<NoteReglementInfo> createState() => _NoteReglementInfoState();
}

class _NoteReglementInfoState extends State<NoteReglementInfo> {
  final TextEditingController _nnn5 = TextEditingController();
  TextEditingController get controller => _nnn5;
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
          "Les Notes de Réglement",
          style: TextStyle(
            fontSize: 17.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String hintText = "Ajouter une Note";
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
            content: SizedBox(
              width: 350,
              child: Column(
                children: [
                  TextField(
                    controller: _nomfournisseur,
                    decoration: const InputDecoration(
                      labelText: 'Nom du Fournisseur',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.work),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _numfacture,
                    decoration: const InputDecoration(
                      labelText: 'N° Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.numbers),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _montantfac,
                    decoration: const InputDecoration(
                      labelText: 'Montant de la Facture',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.attach_money),
                      suffixText: 'DT',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _modepaiment,
                    decoration: const InputDecoration(
                      labelText: 'Mode de Paiment',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.payments),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _datedecheance,
                    decoration: const InputDecoration(
                      labelText: 'Date d\'échéance',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.date_range),
                      
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                ],
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
          ),
        );
      },
    );
  }
}
