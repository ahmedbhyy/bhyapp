import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Taches extends StatefulWidget {
  const Taches({super.key});

  @override
  State<Taches> createState() => _TachesState();
}

class _TachesState extends State<Taches> {
  final TextEditingController _type = TextEditingController();
  final TextEditingController _qte1 = TextEditingController();
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _qte2 = TextEditingController();
  final List<String> items = [
    'Plantation',
    'Récolte',
  ];
  String? selectedValue;
  final List<String> items2 = [
    'Produit fertilisant',
    'produit insecticide',
  ];
  String? selectedValue2;
  @override
  void dispose() {
    super.dispose();
    _type.dispose();
    _qte1.dispose();
    _nom.dispose();
    _qte2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tâches",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Choisissez',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _qte1,
                decoration: const InputDecoration(
                  labelText: 'Qté',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 290),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                    const Text('Ajouter'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Choisissez',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items2
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue2,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue2 = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _nom,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _qte2,
                decoration: const InputDecoration(
                  labelText: 'Qté',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 290),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                    const Text('Ajouter'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
