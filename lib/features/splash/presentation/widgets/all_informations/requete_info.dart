import 'package:flutter/material.dart';

class RequeteInfo extends StatefulWidget {
  const RequeteInfo({super.key});

  @override
  State<RequeteInfo> createState() => _RequeteInfoState();
}

class _RequeteInfoState extends State<RequeteInfo> {
  final TextEditingController _administrative = TextEditingController();
  final TextEditingController _achatdivers = TextEditingController();
  final TextEditingController _cccc = TextEditingController();
  TextEditingController get controller => _cccc;
  @override
  void dispose() {
    super.dispose();
    _administrative.dispose();
    _achatdivers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Requêtes",
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
              String hintText = "Ajouter une Requête ";
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
        children: [],
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
              width: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _administrative,
                    decoration: const InputDecoration(
                      labelText: 'Requête administratives',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _achatdivers,
                    decoration: const InputDecoration(
                      labelText: 'Achat Divers',
                      labelStyle: TextStyle(fontSize: 20),
                      icon: Icon(Icons.shopping_bag),
                    ),
                    maxLines: null,
                  ),
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
