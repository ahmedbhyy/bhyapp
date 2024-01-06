import 'dart:io';
import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/quinz_ouvrier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class ParcelleHome extends StatefulWidget {
  const ParcelleHome({super.key});

  @override
  State<ParcelleHome> createState() => _ParcelleHomeState();
}

class _ParcelleHomeState extends State<ParcelleHome> {
  bool _isLoading = true;
  final controller = TextEditingController();
  final search = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  List<Parcelle> parcelles = [];

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    db.collection("terre").get().then((qsnap) {
      setState(() {
        parcelles = qsnap.docs
            .map((ouvier) =>
                Parcelle(name: ouvier.data()["nom"], id: ouvier.id))
            .toList();
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sparcelles = parcelles
        .where((element) =>
        element.name.toLowerCase().contains(search.text.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 0.0,
        title: const Text(
          "Les Parcelles",
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
              String hintText = "Ajouter une Parcelle";
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
                onChanged: (value) => setState(() {}),
                style: const TextStyle(fontSize: 17.0),
                controller: search,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    labelText: "chercher une Parcelle (${sparcelles.length})",
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
                  itemCount: sparcelles.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      sparcelles[index].name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('voir plus'),
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
                                  await deleteOuvrier(sparcelles[index].id);
                                  setState(() {
                                    parcelles.remove(sparcelles[index]);
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
                            parcelle: sparcelles[index],
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
    for (DateTime d = startDate;
        d.isBefore(endDate.add(const Duration(days: 1)));
        d = d.add(const Duration(days: 1))) {
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
      final idate =
          picked.day > 15 ? picked.copyWith(day: 16) : picked.copyWith(day: 1);
      final fdate = picked.day > 15
          ? picked
              .copyWith(month: picked.month + 1, day: 1)
              .subtract(const Duration(days: 1))
          : picked.copyWith(day: 15);
      final db = FirebaseFirestore.instance;
      final transportDocs = await db
          .collection("quinz_money")
          .where('date', isLessThanOrEqualTo: fdate)
          .where('date', isGreaterThanOrEqualTo: idate)
          .get();
      final transports = transportDocs.docs.map<Map<String, dynamic>>((e) => {
            "person": e['ouvrier'],
            "data": {
              "day": (e['date'] as Timestamp).toDate().day,
              "people": (e['montant'] as double).toInt()
            },
          });
      final databyouvrier = {};
      final uppercaseLetters =
          List.generate(26, (index) => String.fromCharCode(index + 65));
      for (var transport in transports) {
        if (databyouvrier.containsKey(transport["person"])) {
          (databyouvrier[transport["person"]] as List).add(transport["data"]);
        } else {
          databyouvrier[transport["person"]] = [transport["data"]];
        }
      }
      final ouvDocs = await db.collection("quinz_ouvrier").get();
      final ouv = ouvDocs.docs.map((e) => {
            "id": e.id,
            "nom": e['nom'],
            "salaire": e["salaire"],
            "terre": e["terre"],
          });
      final ouvbyid = {};
      for (var e in ouv) {
        ouvbyid[e['id']] = {
          "nom": e['nom'],
          "salaire": e["salaire"],
          "terre": e["terre"],
        };
      }


      var excel = Excel.createExcel();
      Sheet sheetObject = excel["Sheet1"];
      for (var parcelle in parcelles) {
        sheetObject.appendRow([TextCellValue(parcelle.name)]);
        List<String> headers = ["Transp"];
        final dayslist = getDaysInBetween(idate, fdate);
        headers.addAll(dayslist.map((e) => e.toString()));
        headers.addAll(["Tot", "Sal/Jr", "Montant"]);
        sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());
        ouvbyid.forEach((key, value) {
          if (value["terre"] == parcelle.id && databyouvrier.containsKey(key)) {
            List<CellValue?> head = [TextCellValue(value["nom"])];
            for (int i = 0; i < dayslist.length; i++) {
              head.add(const TextCellValue(
                  "0")); // Assuming generateElement is a function that generates an element based on i
            }
            int tot = 0;
            for (var element in (databyouvrier[key] as List)) {
              head[dayslist.indexOf(element["day"]) + 1] =
                  TextCellValue(element["people"].toString());
              tot = tot + element['people'] as int;
            }
            head.addAll([
              TextCellValue(tot.toString()),
              TextCellValue(value['salaire'].toString()),
              TextCellValue((value['salaire'] * tot).toString())
            ]);
            sheetObject.appendRow(head);
          }
        });
        sheetObject.appendRow([null]);
      }
      PdfApi.openFile(
          await PdfApi.saveDocumentexcel(name: "a.xlsx", excel: excel));
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
                      labelText: 'nom de la Parcelle',
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
                        ouvrier.add({'nom': newName}).then((value) {
                          Parcelle newOuvrier =
                              Parcelle(name: newName, id: value.id);
                          setState(() {
                            parcelles.add(newOuvrier);
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


class Parcelle {
  final String name;
  final String id;
  Parcelle({required this.name, required this.id});
}

