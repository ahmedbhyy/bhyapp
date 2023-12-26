import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart';
import 'dart:io';


class Utils {
  static formatPrice(double price) => '${price.toStringAsFixed(2)}TND';
  static formatDate(DateTime date) =>  DateFormat.yMMMMd('fr_FR').format(date);
}

class InvoicApi {

  static Future<File> generateBonSortie({required List<Map<String, dynamic>> items, required DateTime date, required String num, required String title, required String client, required String address}) async {
    await initializeDateFormatting();
    final pdf = Document();
    final header = await buildHeader(title: "Bon de Sortie", num: num, date:date);
    pdf.addPage(MultiPage(
     pageFormat: pw.PdfPageFormat.a4,
      build: (context) => [
        header,
        SizedBox(height: 15 * pw.PdfPageFormat.mm),
        Text("Client: $client\nAdresse: ${address}  Tel: ..........................\nM.F: .......................................\nNombre de produits: ${items.length}", style: TextStyle(lineSpacing: 1.6 * pw.PdfPageFormat.mm)),
        SizedBox(height: 9*pw.PdfPageFormat.mm,),
        //table Code
        buildInvoiceBon(items),
        Divider(),
        Align(
          child: Text("Poids Total: ${items.fold(0.0, (prev, next) => prev + next["poids"]*next['quantite'])}"),
          alignment: AlignmentDirectional.bottomEnd
        ),


      ],
      //footer: (context) => buildFooter(invoice),

    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<Widget> buildHeader({required String title, required String num, required DateTime date})  async{
    final memoryImage = MemoryImage((await rootBundle.load("images/print.png")).buffer.asUint8List()); 

  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 2.5 * pw.PdfPageFormat.cm, child: Image(memoryImage),),
              Text("Adresse: 020, Ibn Battouta, Rades 2040\nTel: (+216) 79 490 323\nMF: 0987104/Q", style:  const TextStyle(
              lineSpacing: 1.6 * pw.PdfPageFormat.mm
              )),
          ]
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: .3 * pw.PdfPageFormat.cm),
          Text(title, style:  TextStyle(fontSize: 13 * pw.PdfPageFormat.mm, fontWeight: FontWeight.bold)),
          SizedBox(height: .7 * pw.PdfPageFormat.cm),
          Text(" N°: $num\n Date: le ${Utils.formatDate(date)}", style: TextStyle(lineSpacing: 4.9 * pw.PdfPageFormat.mm)),
        ])
      ]
  );
  }

  static Widget buildInvoiceBon(List<Map<String, dynamic>> items) {
    final headers = [
      'Code',
      'Description',
      'Qté',
      'Unité',
      'Poids',
      '%TVA'
    ];

    return Table.fromTextArray(
      headers: headers,
      data: items.map((e) => ["", e["des"], e["quantite"], e["unit"], e["poids"], e["tva"] * 100]).toList(),
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: pw.PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0:  const FixedColumnWidth(1.1 * pw.PdfPageFormat.cm)
      },
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

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * pw.PdfPageFormat.mm),
        Text(value),
      ],
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

  static Future openFile(File file) async {
    final url = file.path;
  print(url);
    await OpenFilex.open(url);
  }
}
