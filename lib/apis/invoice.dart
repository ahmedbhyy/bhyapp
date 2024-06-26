import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart';
import 'dart:io';

class Utils {
  static formatPrice(double price) => '${price.toStringAsFixed(3)} DT';
  static intFixed(int n) => n.toString().padLeft(6, "0");
  static factNum(Facture facture) => Utils.intFixed(facture.num) + '/' + facture.date.year.toString();
  static formatDate(DateTime date) => DateFormat.yMMMMd('fr_FR').format(date);
  static formatmy(DateTime date) =>
      DateFormat('MMMM yyyy', 'fr_FR').format(date);
  static formatMoney(double money) => money.toStringAsFixed(3);
}

class InvoicApi {
  static Future<File> generateBonSortie(
      {required List<Map<String, dynamic>> items,
      required DateTime date,
      required String num,
      required String title,
      required String client,
      required String address}) async {
    await initializeDateFormatting();
    final pdf = Document();
    final header = await buildHeader(title: title, num: num, date: date);
    pdf.addPage(MultiPage(
      pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text(
            "Client: $client\nAdresse: $address  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}",
            style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(
          height: 9 * pw.PdfPageFormat.mm,
        ),
        //table Code
        buildInvoiceBon(items),
        Divider(),
        Align(
            child: Text(
                "Poids Total: ${items.fold(0.0, (prev, next) => prev + next["poids"] * next['quantite'])}"),
            alignment: AlignmentDirectional.bottomEnd),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> generateBonlivraison(
      {required List<Map<String, dynamic>> items,
      required DateTime date,
      required String num,
      required String title,
      required String client,
      required String address}) async {
    await initializeDateFormatting();
    final pdf = Document();
    final header = await buildHeader(title: title, num: num, date: date);
    pdf.addPage(MultiPage(
      pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text(
            "Client: $client\nAdresse: $address  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}",
            style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(
          height: 9 * pw.PdfPageFormat.mm,
        ),
        //table Code
        buildInvoiceBon(items),
        Divider(),
        Align(
            child: Text(
                "Poids Total: ${items.fold(0.0, (prev, next) => prev + next["poids"] * next['quantite'])}"),
            alignment: AlignmentDirectional.bottomEnd),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> generateFacture(
      {required List<Map<String, dynamic>> items,
      required DateTime date,
      bool? riadh,
      required String num,
      required String title,
      required String client,
      required String address}) async {
    await initializeDateFormatting();

    final pdf = Document();
    final header =
        await buildHeader(title: title, num: num, date: date, riadh: riadh);
    pdf.addPage(MultiPage(
      pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text(
            "Client: $client\nAdresse: $address  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}",
            style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(
          height: 9 * pw.PdfPageFormat.mm,
        ),
        //table Code
        buildFacture(items),
        Divider(),
        buildTotal(items),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> generateFacture3(
      {required List<Map<String, dynamic>> items,
      required DateTime date,
      required String num,
      required String title,
      required String client,
      double size = 13,
      required String address}) async {
    await initializeDateFormatting();

    final pdf = Document();
    final header =
        await buildHeader(title: title, num: num, date: date, size: size);
    pdf.addPage(MultiPage(
      pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text(
            "Client: $client\nAdresse: $address  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}",
            style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(
          height: 9 * pw.PdfPageFormat.mm,
        ),
        //table Code
        buildFacture3(items),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> generateFacture2(
      {required List<Map<String, dynamic>> items,
      required DateTime date,
      required String num,
      required String title,
      required String client,
      required String address}) async {
    await initializeDateFormatting();

    final pdf = Document();
    final header = await buildHeader(title: title, num: num, date: date);
    pdf.addPage(MultiPage(
      pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text(
            "Client: $client\nAdresse: $address  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}",
            style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(
          height: 9 * pw.PdfPageFormat.mm,
        ),
        //table Code
        buildFacture2(items),
        Divider(),
        buildTotal2(items),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTotal(List<Map<String, dynamic>> items) {
    final totalTTC = items.fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element['quantite'] * element['montant'] * (1 - element['remise']));
    final totalhc = items.fold(
        0.0,
        (prev, next) =>
            prev +
            next['quantite'] *
                (next['montant'] / (1 + next['tva'] / 100)) *
                (1 - next['remise']));
    final totaltva = items.fold(
        0.0,
        (prev, next) =>
            prev +
            next['quantite'] *
                (1 - next['remise']) *
                (next['montant'] /
                    (1 + next['tva'] / 100) *
                    next['tva'] /
                    100));

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'total HT',
                  value: Utils.formatPrice(totalhc),
                  unite: true,
                ),
                SizedBox(height: 5),
                buildText(
                  title: 'total TVA',
                  value: Utils.formatPrice(totaltva),
                  unite: true,
                ),
                SizedBox(height: 5),
                buildText(
                  title: 'timbre fiscale',
                  value: "1.000 DT",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total TTC',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(totalTTC + 1.0),
                  unite: true,
                ),
                SizedBox(height: 2 * pw.PdfPageFormat.mm),
                Container(height: 1, color: pw.PdfColors.grey400),
                SizedBox(height: 0.5 * pw.PdfPageFormat.mm),
                Container(height: 1, color: pw.PdfColors.grey400),
                SizedBox(height: 20 * pw.PdfPageFormat.mm),
                Center(
                  child: Text('Signature',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: pw.PdfColors.grey100,
                  ),
                  width: double.infinity,
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTotal2(List<Map<String, dynamic>> items) {
    final totalTTC = items.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element['quantite'] * element['unit']);
    final totalhc = items.fold(
        0.0,
        (prev, next) =>
            prev + next['quantite'] * (next['unit'] / (1 + next['tva'])));
    final totaltva = items.fold(
        0.0,
        (prev, next) =>
            prev +
            next['quantite'] *
                (next['unit'] / (1 + next['tva']) * next['tva']));

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'total HT',
                  value: Utils.formatPrice(totalhc),
                  unite: true,
                ),
                buildText(
                  title: 'total TVA',
                  value: Utils.formatPrice(totaltva),
                  unite: true,
                ),
                buildText(
                  title: 'timbre fiscale',
                  value: "1.000 DT",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total TTC',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(totalTTC + 1.0),
                  unite: true,
                ),
                SizedBox(height: 2 * pw.PdfPageFormat.mm),
                Container(height: 1, color: pw.PdfColors.grey400),
                SizedBox(height: 0.5 * pw.PdfPageFormat.mm),
                Container(height: 1, color: pw.PdfColors.grey400),
                SizedBox(height: 20 * pw.PdfPageFormat.mm),
                Center(
                  child: Text('Signature',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    color: pw.PdfColors.grey100,
                  ),
                  width: double.infinity,
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Future<Widget> buildHeader(
      {required String title,
      required String num,
      double size = 13,
      bool? riadh,
      required DateTime date}) async {
    final memoryImage = riadh == null
        ? MemoryImage((await rootBundle.load("images/logo.png"))
            .buffer
            .asUint8List())
        : MemoryImage(
            (await rootBundle.load("images/riadh.png")).buffer.asUint8List());

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 2.5 * pw.PdfPageFormat.cm,
              child: Image(memoryImage),
            ),
            SizedBox(height: 10),
            Text(
                riadh == null
                    ? "Adresse: 020, Ibn Battouta, Rades 2040\nTel: (+216) 79 490 323\nMF: 0987104/Q"
                    : "Adresse: Henchir Kort / Nabeul 8000\nTel: (+216) 79 490 323\nMF: 0987104/Q",
                style: const TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SizedBox(height: .3 * pw.PdfPageFormat.cm),
            Text(title,
                style: TextStyle(
                    fontSize: size * pw.PdfPageFormat.mm,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: .7 * pw.PdfPageFormat.cm),
            Align(
              alignment: Alignment.topRight,
              child: Text(" N°: $num\n Date: le ${Utils.formatDate(date)}",
                  style: TextStyle(
                      lineSpacing: 4.9 * pw.PdfPageFormat.mm,
                      fontWeight: FontWeight.bold)),
            )
          ])
        ]);
  }

  static Widget buildInvoiceBon(List<Map<String, dynamic>> items) {
    final headers = ['Code', 'Description', 'Qté', 'Unité', 'Poids', '%TVA'];

    return Table.fromTextArray(
      headers: headers,
      data: items
          .map((e) => [
                "",
                e["des"],
                e["quantite"],
                e["unit"],
                e["poids"],
                e["tva"] * 100
              ])
          .toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {0: const FixedColumnWidth(1.1 * pw.PdfPageFormat.cm)},
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildInvoiceliv(List<Map<String, dynamic>> items) {
    final headers = [
      'Code',
      'Description',
      'Qté',
      'Unité',
      'P.U.H.T',
      '%TVA',
      'Prix Total'
    ];

    return Table.fromTextArray(
      headers: headers,
      data: items
          .map((e) => [
                "",
                e["des"],
                e["quantite"],
                e["unit"],
                e["poids"],
                e["tva"] * 100
              ])
          .toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {0: const FixedColumnWidth(1.1 * pw.PdfPageFormat.cm)},
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildFacture(List<Map<String, dynamic>> items) {
    final headers = [
      'Description',
      'Qté',
      'Unité',
      'P.U.H.T',
      '%TVA',
      'Remise %',
      'Prix Total'
    ];

    return Table.fromTextArray(
      headers: headers,
      data: items
          .map((e) => [
                e["des"],
                e["quantite"],
                Utils.formatMoney(e["montant"].toDouble()),
                Utils.formatMoney(e['montant'] / (1 + e['tva'] / 100)),
                e['tva'],
                e['remise'] * 100,
                Utils.formatMoney(
                    (e["montant"] * e["quantite"]) * (1 - e['remise'])),
              ])
          .toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.centerRight,
      },
    );
  }

  static Widget buildFacture3(List<Map<String, dynamic>> items) {
    final headers = ['Code', 'Description', 'Qté'];

    return Table.fromTextArray(
      headers: headers,
      data: items
          .map((e) => [
                "",
                e["des"],
                e["quantite"],
              ])
          .toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(1)
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.centerRight,
      },
    );
  }

  static Widget buildFacture2(List<Map<String, dynamic>> items) {
    final headers = [
      'Code',
      'Description',
      'Qté',
      'Unité',
      'P.U.H.T',
      '%TVA',
      'Prix Total'
    ];

    return Table.fromTextArray(
      headers: headers,
      data: items
          .map((e) => [
                "",
                e["des"],
                e["quantite"],
                e["unit"],
                Utils.formatMoney(e['unit'] / (1 + e['tva'])),
                e['tva'] * 100,
                e["unit"] * e["quantite"],
              ])
          .toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {0: const FixedColumnWidth(1.8 * pw.PdfPageFormat.cm)},
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> saveDocumentexcel({
    required String name,
    required Excel excel,
  }) async {
    final bytes = excel.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes!);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFilex.open(url);
  }
}
