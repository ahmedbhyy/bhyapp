import 'package:flutter/material.dart';

class Commandes extends StatefulWidget {
  const Commandes({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Commandes createState() => _Commandes();
}

class _Commandes extends State<Commandes> {
  List<Widget> descriptionFields3 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Commandes",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addDescriptionTextField2();
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            for (var field in descriptionFields3) field,
          ],
        ),
      ),
    );
  }

  void _addDescriptionTextField2() {
    setState(() {
      descriptionFields3.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(fontSize: 17.0),
                maxLines: null,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 8.0),
                  hintText: "décrire la Commande",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enregister'),
            ),
          ],
        ),
      );
    });
  }
}
