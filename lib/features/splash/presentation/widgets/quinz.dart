import 'dart:io';

import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_details.dart';
import 'package:bhyapp/features/splash/presentation/widgets/quinz_ouvrier.dart';
import 'package:bhyapp/ouvrier/ouvrier_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class TerreHome extends StatefulWidget {
  const TerreHome({super.key});

  @override
  State<TerreHome> createState() => _TerreHomeState();
}

class _TerreHomeState extends State<TerreHome> {
  bool _isLoading = true;
  final TextEditingController _nomdeouvrier = TextEditingController();
  TextEditingController get controller => _nomdeouvrier;

  @override
  void dispose() {
    _nomdeouvrier.dispose();
    super.dispose();
  }

  List<Ouvriername2> displayList = [];
  List<Ouvriername2> originalList = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db.collection("terre").get().then((qsnap) {
      setState(() {
        originalList = qsnap.docs
            .map((ouvier) => Ouvriername2(
                name: ouvier.data()["nom"],
                id: ouvier.id))
            .toList();
        displayList = List.from(originalList);
        _isLoading = false;
      });
    });
    super.initState();
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displayList = List.from(originalList);
      } else {
        displayList = originalList
            .where((element) =>
                element.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 0.0,
        title: const Text(
          "Les terres",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'Michroma'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calculate_outlined,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () {
              _selectDate(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_home_work_outlined,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () {
              String hintText = "Ajouter une terre";
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
                    labelText: "chercher une terre (${displayList.length})",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                    )),
              ),
              const SizedBox(height: 10.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                    ))
                  : Container(),
              Expanded(
                child: ListView.separated(
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      displayList[index].name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('voir plus'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Confirmer la Suppression',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            content: const Text(
                              'Vous êtes sûr ?',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await deleteOuvrier(displayList[index].id);
                                  setState(() {
                                    displayList.removeAt(index);
                                  });
                                },
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuinzOuvrier(
                            terre: displayList[index],
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
  List<int> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<int> days = [];
    for (DateTime d = startDate; d.isBefore(endDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
      days.add(d.day);
    }
    return days;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
        final idate = picked.day > 15 ? picked.copyWith(day: 16): picked.copyWith(day: 1);
        final fdate = picked.day > 15 ? picked.copyWith(month: picked.month+1, day:1).subtract(const Duration(days: 1)) : picked.copyWith(day:15);
        final db = FirebaseFirestore.instance;
        final money_docs = await db.collection("quinz_money").where('date', isLessThanOrEqualTo: fdate).where('date', isGreaterThanOrEqualTo: idate).get();
        final money = money_docs.docs.map<Map<String,dynamic>>((e) => {
          "person": e['ouvrier'],
          "data": {
            "day": (e['date'] as Timestamp).toDate().day,
            "people": (e['montant'] as double).toInt()
          },

        });
        final databyouvrier = {};
        final uppercaseLetters = List.generate(26, (index) => String.fromCharCode(index + 65));
        money.forEach((element) {
          if(databyouvrier.containsKey(element["person"])) {
            (databyouvrier[element["person"]] as List).add(element["data"]);
          } else {
            databyouvrier[element["person"]] = [element["data"]];
          }
        });
        final ouv_docs = await db.collection("quinz_ouvrier").get();
        final ouv = ouv_docs.docs.map((e) => {
          "id": e.id,
          "nom": e['nom'],
          "salaire": e["salaire"],
          "terre": e["terre"],
        });
        final ouvbyid = {};
        ouv.forEach((e) { ouvbyid[e['id']] = {
          "nom": e['nom'],
          "salaire": e["salaire"],
          "terre": e["terre"],
        }; });
        print(databyouvrier);
        print(ouvbyid);
        var excel = Excel.createExcel();
        Sheet sheetObject = excel["Sheet1"];
        originalList.forEach((terre) {
          sheetObject.appendRow([TextCellValue(terre.name)]);
          List<String> headers = ["Transp"];
          headers.addAll(getDaysInBetween(idate, fdate).map((e) => e.toString()));
          headers.addAll(["Tot", "Sal/Jr", "Montant"]);
          sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());
          final dayslist = getDaysInBetween(idate, fdate);
          ouvbyid.forEach((key, value) {
            if(value["terre"] == terre.id && databyouvrier.containsKey(key)) {
              List<CellValue?> head = [TextCellValue(value["nom"])];
              for (int i = 0; i < dayslist.length; i++) {
                head.add(TextCellValue("0"));// Assuming generateElement is a function that generates an element based on i
              }
              int tot = 0;
              (databyouvrier[key] as List).forEach((element) {
                head[dayslist.indexOf(element["day"]) + 1] = TextCellValue(element["people"].toString());
                tot = tot + element['people'] as int;
              });
              head.addAll([TextCellValue(tot.toString()), TextCellValue(value['salaire'].toString()), TextCellValue((value['salaire']*tot).toString())]);
              sheetObject.appendRow(head);
              sheetObject.appendRow([null]);
            }
          });
        });
        PdfApi.openFile(await PdfApi.saveDocumentexcel(name: "a.xlsx", excel: excel));
    }
  }

  Future<void> deleteOuvrier(String ouvrierId) async {
    try {
      final db = FirebaseFirestore.instance;
      final ouvrierRef = db.collection('terre').doc(ouvrierId);

      await ouvrierRef.delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("element Deleted"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("une erreur est survenue veuillez réessayer ultérieurement"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, ss) => AlertDialog(
            title: Text(hintText),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'nom de la terre',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  String newName = controller.text;
                  if (newName.isNotEmpty) {
                    setState(() {
                      if (newName.isNotEmpty) {
                        final db = FirebaseFirestore.instance;
                        final ouvrier = db.collection("terre");
                        ouvrier.add({'nom': newName}).then(
                            (value) {
                          Ouvriername2 newOuvrier = Ouvriername2(
                              name: newName, id: value.id);
                          setState(() {
                            displayList.add(newOuvrier);
                          });
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
          ),
        );
      },
    );
  }
}
