import 'dart:io';
import 'dart:math';
import 'package:bhyapp/apis/invoice.dart';
import 'package:bhyapp/features/splash/presentation/widgets/depense.dart';
import 'package:bhyapp/features/splash/presentation/widgets/quinz_ouvrier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';


class ParcelleHome extends StatefulWidget {
  const ParcelleHome({super.key});

  @override
  State<ParcelleHome> createState() => _ParcelleHomeState();
}

class _ParcelleHomeState extends State<ParcelleHome> {
  bool _isLoading = true;
  final controller = TextEditingController();
  final search = TextEditingController();
  final ferme = TextEditingController();

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
            .map((parcelle) =>
                Parcelle(name: parcelle.data()["nom"], id: parcelle.id, firme: parcelle.data()['firme']))
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
              Icons.savings_outlined,
              size: Platform.isAndroid ? 24 : 45,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DepenseHome()));
            },
          ),
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
                    subtitle: Text('${sparcelles[index].firme} | voir plus'),
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
      if(!context.mounted) return;
      final firma = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, ss) => AlertDialog(
            title: const Text("la ferme"),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: ferme,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'nom de la ferme',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  final ff = ferme.text;
                  Navigator.pop(context, ff);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
      );
    if(firma == null) return;
      final sauce =  picked.day > 15 ? 1 : 0;
      final idate =
          sauce==1 ? picked.copyWith(day: 16) : picked.copyWith(day: 1);
      final fdate = sauce==1
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


      var excel = ex.Excel.createExcel();
      ex.Sheet sheetObject = excel["Sheet1"];
      for(int i = 2; i< 23;i++) {
        sheetObject.setColumnWidth(i, 3);
      }
      int x=0;
      List<String> ids = [];
      int lasty=0;
      List<List<String>> last = [];
      for (var parcelle in parcelles) {
        if(parcelle.firme != firma) continue;
        final titleCell = sheetObject.cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: x++));
        titleCell.value = ex.TextCellValue(parcelle.name);
        writeTextCell(sheet: sheetObject, value: "Transp", x: x, y:0);
        final dayslist = getDaysInBetween(idate, fdate);
        int y = 1;
        for (var day in dayslist) {
          writeIntCell(x: x, y: y++, sheet: sheetObject, value: day);
        }
        writeTextCell(sheet: sheetObject, value: "Tot", x: x, y: y++);
        writeTextCell(sheet: sheetObject, value: "Sal/Jr", x: x, y: y++);
        writeTextCell(sheet: sheetObject, value: "Montant", x: x, y: y++);
        x++;
        y=0;
        int firstx=x;
        ouvbyid.forEach((key, value) {
          if (value["terre"] == parcelle.id && databyouvrier.containsKey(key)) {
            writeTextCell(sheet: sheetObject, value: value["nom"], x: x, y: y++);
            for (var element in (databyouvrier[key] as List)) {
              writeIntCell(x: x, y: element["day"] + 1, sheet: sheetObject, value: element['people']);
            }
            y=dayslist.length + 1;
            final lastcell = ex.CellIndex.indexByColumnRow(columnIndex: y-1, rowIndex: x).cellId;
            writeFormulaCell(sheet: sheetObject, value: "=SUM(B${x+1}:$lastcell)", x: x, y: y);
            for(int i = 1; i<= uppercaseLetters.indexOf(lastcell[0]);i++) {
              final cell = sheetObject.cell(ex.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: x));
              cell.cellStyle = ex.CellStyle(
                numberFormat: ex.NumFormat.standard_0,
                leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
                rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
                topBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
                bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thin),
              );
            }
            final total = ex.CellIndex.indexByColumnRow(columnIndex: y++, rowIndex: x).cellId;
            final salaire = ex.CellIndex.indexByColumnRow(columnIndex: y, rowIndex: x).cellId;
            writeDoubleCell(x: x, y: y++, sheet: sheetObject, value: value['salaire']);
            writeFormulaCell(sheet: sheetObject, value: "=$total*$salaire", x: x, y: y);
            x++;
            lasty = y;
            y=0;
          }
        });
          final fr = ex.CellIndex.indexByColumnRow(columnIndex: lasty, rowIndex: firstx).cellId;
          final lr = ex.CellIndex.indexByColumnRow(columnIndex: lasty, rowIndex: x-1).cellId;
          final me = ex.CellIndex.indexByColumnRow(columnIndex: lasty, rowIndex: x);
          ids.add(me.cellId);
          last.add([parcelle.name,me.cellId]);
          writeFormulaCell(sheet: sheetObject, value: "=SUM($fr:$lr)", x: x, y: lasty);
          x++;
      }
      x++;
      await initializeDateFormatting();
      writeTextCell(sheet: sheetObject, value: "Total", x: x, y: lasty-1);
      writeFormulaCell(sheet: sheetObject, value: "=${ids.join("+")}", x: x++, y: lasty);
      writeTextCell(sheet: sheetObject, value: "RECAP  CHARGES ${sauce != 1 ? '1 ère' : '2éme'} QUINZ ${Utils.formatmy(idate)}", x: x++, y: 1);
      writeTextCell(sheet: sheetObject, value: "Parcelle", x: x, y: 1);
      writeTextCell(sheet: sheetObject, value: "Montant", x: x++, y: 2);
      for(var recap in last) {
        writeTextCell(sheet: sheetObject, value: recap[0], x: x, y: 1);
        writeFormulaCell(sheet: sheetObject, value: "=${recap[1]}", x: x++, y: 2);
      }
      x++;
      writeTextCell(sheet: sheetObject, value: "Dépenses Divers", x: x++, y: 1);
      final deps = await db.collection("depense").get();
      double totalfinal = 0;
      for(var doc in deps.docs) {
        final ref = await db.collection("depense").doc(doc.id).collection("items").where('firme', isEqualTo: firma).where('date', isGreaterThanOrEqualTo: idate).where('date', isLessThanOrEqualTo: fdate).get();
        double total = 0;
        for(var dd in ref.docs) {
          final data = dd.data();
          total += data['montant'];
        }

        totalfinal += total;
        writeDoubleCell(x: x, y: 5, sheet: sheetObject, value: total);
        writeTextCell(x: x++, y: 1, sheet: sheetObject, value: doc.id);
      }
      writeTextCell(x: x, y: 1, sheet: sheetObject, value: "Total");
      writeDoubleCell(x: x++, y: 5, sheet: sheetObject, value: totalfinal);
      writeTextCell(sheet: sheetObject, value: "Total Dépenses ${sauce != 1 ? '1 ère' : '2éme'} Quinz ${Utils.formatmy(idate)}", x: x, y: 1);
      PdfApi.openFile(
          await PdfApi.saveDocumentexcel(name: "$firma ${Random().nextInt(20000)}.xlsx", excel: excel));
    }
  }

  writeIntCell({required int x, required int y, required ex.Sheet sheet, int? value, ex.CellStyle? style}) {
    final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: y, rowIndex: x));
        cell.value = value != null ? ex.IntCellValue(value) : null;
        cell.cellStyle = style ?? ex.CellStyle(
          leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          topBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
        );
        cell.cellStyle?.numberFormat = ex.NumFormat.standard_0;
  }

    writeDoubleCell({required int x, required int y, required ex.Sheet sheet, double? value, ex.CellStyle? style}) {
    final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: y, rowIndex: x));
        cell.value = value != null ? ex.TextCellValue(value.toStringAsFixed(3).replaceAll(".", ",")) : null;
        cell.cellStyle = style ?? ex.CellStyle(
          leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          topBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
          bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
        );
        //cell.cellStyle?.numberFormat = ex.NumFormat.standard_2;
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
                      labelText: 'Nom de la Parcelle',
                    ),
                  ),
                  TextField(
                    controller: ferme,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la ferme',
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
                        ouvrier.add({'nom': newName, 'firme': ferme.text}).then((value) {
                          Parcelle newOuvrier =
                              Parcelle(name: newName, id: value.id, firme: ferme.text );
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
  
  void writeTextCell({required ex.Sheet sheet, required String value, required int x, required int y, ex.CellStyle? style}) {
    final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: y, rowIndex: x));
    cell.value = ex.TextCellValue(value);
    cell.cellStyle = style ?? ex.CellStyle(
    leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    topBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
  );
  }
  void writeFormulaCell({required ex.Sheet sheet, required String value, required int x, required int y, ex.CellStyle? style}) {
    final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: y, rowIndex: x));
    cell.value = ex.FormulaCellValue(value);
    cell.cellStyle = style ?? ex.CellStyle(
    leftBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    rightBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    topBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
    bottomBorder: ex.Border(borderStyle: ex.BorderStyle.Thick),
  );
  }
}


class Parcelle {
  final String name;
  final String id;
  final String firme;
  Parcelle({required this.name, required this.id, required this.firme});
}