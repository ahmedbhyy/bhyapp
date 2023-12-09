import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_details.dart';
import 'package:bhyapp/ouvrier/ouvrier_name.dart';
import 'package:flutter/material.dart';

class OuvrierHome extends StatefulWidget {
  const OuvrierHome({super.key});

  @override
  State<OuvrierHome> createState() => _OuvrierHomeState();
}

class _OuvrierHomeState extends State<OuvrierHome> {
  // ignore: non_constant_identifier_names
  static List<Ouvriername> main_ouvrier_list = [
    Ouvriername(
      ouvrier_name: "Hmida bel haj yahia",
    ),
    Ouvriername(
      ouvrier_name: "salah",
    ),
    Ouvriername(
      ouvrier_name: "ahmed",
    ),
    Ouvriername(
      ouvrier_name: "mohamed",
    ),
    Ouvriername(
      ouvrier_name: "yassine",
    ),
    Ouvriername(
      ouvrier_name: "youssef",
    ),
    Ouvriername(
      ouvrier_name: "wassime",
    ),
    Ouvriername(
      ouvrier_name: "mounir",
    ),
    Ouvriername(
      ouvrier_name: "samir",
    ),
  ];
  // ignore: non_constant_identifier_names
  List<Ouvriername> display_list = List.from(main_ouvrier_list);
  void updateList(String value) {
    setState(() {
      display_list = main_ouvrier_list
          .where((element) =>
              element.ouvrier_name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
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
          "Les ouvriers",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'Michroma'),
        ),
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
                    hintText: "chercher un ouvrier",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
                    )),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.separated(
                  itemCount: display_list.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      display_list[index].ouvrier_name ?? "No Name",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OuvrierDetails(
                            Ouvriername: display_list[index].ouvrier_name!,
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
}
