import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class ToutsCommandes extends StatefulWidget {
  const ToutsCommandes({super.key});

  @override
  State<ToutsCommandes> createState() => _ToutsCommandesState();
}

class _ToutsCommandesState extends State<ToutsCommandes> {
  final TextEditingController _nnn4 = TextEditingController();
  TextEditingController get controller => _nnn4;
  TextEditingController _datedecomeng = TextEditingController();
  final TextEditingController _qte1 = TextEditingController();
  final TextEditingController _qte2 = TextEditingController();
  final TextEditingController _qte3 = TextEditingController();
  final TextEditingController _qte4 = TextEditingController();
  final TextEditingController _qte5 = TextEditingController();
  final TextEditingController _qte6 = TextEditingController();
  final TextEditingController _qte7 = TextEditingController();
  final TextEditingController _qte8 = TextEditingController();
  final TextEditingController _qte9 = TextEditingController();
  final TextEditingController _totalcommeng = TextEditingController();
  final TextEditingController _destinationcommeng = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _datedecomeng.dispose();
    _qte1.dispose();
    _qte2.dispose();
    _qte3.dispose();
    _qte4.dispose();
    _qte5.dispose();
    _qte6.dispose();
    _qte7.dispose();
    _qte8.dispose();
    _qte9.dispose();
    _totalcommeng.dispose();
    _destinationcommeng.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tous les commandes",
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
              String hintText = "Ajouter une Commande";
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
        return AlertDialog(
          title: Text(hintText),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
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
                      label: Text("Date de Commande"),
                    ),
                    onComplete: (date) {
                      setState(() {
                        _datedecomeng = date as TextEditingController;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _qte1,
                              decoration: const InputDecoration(
                                labelText: 'Ultra-Solution D.R.C Irrigation',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _qte2,
                              decoration: const InputDecoration(
                                labelText: 'Ultra Plus 45',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _qte3,
                              decoration: const InputDecoration(
                                labelText: 'Ultra Classic 45',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _qte4,
                              decoration: const InputDecoration(
                                labelText: 'Ultra DRC Foliar TDS',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _qte5,
                              decoration: const InputDecoration(
                                labelText: 'Actiphol',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _qte6,
                              decoration: const InputDecoration(
                                labelText: 'Rhizocote',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _qte7,
                              decoration: const InputDecoration(
                                labelText: 'Power Set',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _qte8,
                              decoration: const InputDecoration(
                                labelText: 'Clustflo',
                                suffixText: 'Qté',
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextField(
                    controller: _qte9,
                    decoration: const InputDecoration(
                      labelText: 'ANIMAX',
                      suffixText: 'Qté',
                      labelStyle: TextStyle(fontSize: 15),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _destinationcommeng,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      suffixIcon: Icon(Icons.place),
                      labelStyle: TextStyle(fontSize: 15),
                    ),
                    maxLines: null,
                  ),
                  TextField(
                    controller: _totalcommeng,
                    decoration: const InputDecoration(
                      labelText: 'Montant Total',
                      suffixText: 'DT',
                      labelStyle: TextStyle(fontSize: 15),
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
