import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TachesAjout extends StatefulWidget {
  const TachesAjout({super.key});

  @override
  State<TachesAjout> createState() => _TachesAjoutState();
}

class _TachesAjoutState extends State<TachesAjout> {
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
          padding: const EdgeInsets.all(50.0),
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
                  labelText: "description de l'activité",
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _qte1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'quantité',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              const SizedBox(
                height: 20,
              ),
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'quantité',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                maxLines: null,
              ),
              const SizedBox(
                height: 50,
              ),
              FilledButton(
                onPressed: () {
                  if (selectedValue == null && selectedValue2 == null) {
                    Navigator.pop(context);
                    return;
                  }
                  Navigator.pop(context, {
                    'job': selectedValue == null
                        ? null
                        : Job(
                            type: selectedValue!,
                            desc: _type.text,
                            qte: int.parse(_qte1.text)),
                    'item': selectedValue2 == null
                        ? null
                        : Item(
                            type: selectedValue2!,
                            nom: _nom.text,
                            qte: int.parse(_qte2.text))
                  });
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final List<Job> jobs;
  final List<Item> items;
  final Future<void> Function(Job) updatejobs;
  final Future<void> Function(Item) updateitems;
  const TaskList(
      {super.key,
      required this.jobs,
      required this.items,
      required this.updatejobs,
      required this.updateitems});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Job> jobs = [];
  List<Item> items = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    jobs = widget.jobs;
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () async {
            final res = await Navigator.push<Map<String, dynamic>>(context,
                MaterialPageRoute(builder: (context) => const TachesAjout()));
            final job = res?['job'] as Job?;
            final item = res?['item'] as Item?;
            if (job != null) {
              widget.updatejobs(job);
            }

            if (item != null) {
              widget.updateitems(item);
            }

            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: "activité",
            ),
            Tab(
              text: "Utilisation d'engrais",
            ),
          ]),
          title: const Text(
            "Tâches",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Michroma',
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        body: TabBarView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Expanded(
                child: ListView.separated(
                  itemCount: jobs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return ListTile(
                      leading: Icon(
                        Icons.agriculture_outlined,
                        color: Colors.green.shade600,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      isThreeLine: true,
                      subtitle: Text(
                        job.type,
                        style: TextStyle(color: Colors.green.shade500),
                      ),
                      title: Text(job.desc,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Icon(
                        Icons.payments,
                        color: Colors.green.shade600,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      isThreeLine: true,
                      subtitle: Text(
                        item.type,
                        style: TextStyle(color: Colors.green.shade500),
                      ),
                      title: Text(item.nom,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
