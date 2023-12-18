import 'package:date_format_field/date_format_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class RapportAdmin extends StatefulWidget {
  const RapportAdmin({super.key});

  @override
  State<RapportAdmin> createState() => _RapportAdminState();
}

class _RapportAdminState extends State<RapportAdmin> {
  final TextEditingController _lieufirme = TextEditingController();
  TextEditingController get controller => _lieufirme;
  final List<String> items3 = [
    'Tous',
    'Nabeul',
    'kebeli',
    'Regueb',
  ];
  String? selectedValue3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Rapports",
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
              String hintText = "Chercher un Détail";
              selectedValue3 = null;
              showEditDialog(context, hintText, controller);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.green,
              size: 35,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context, String hintText,
      TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, st) => SingleChildScrollView(
            child: AlertDialog(
              title: Text(hintText),
              content: SizedBox(
                width: 300,
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
                        label: Text("Date"),
                      ),
                      onComplete: (date) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
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
                          items: items3
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
                          value: selectedValue3,
                          onChanged: (String? value) {
                            selectedValue3 = value;
                            st(() {});
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
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
