import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequeteInfo extends StatefulWidget {
  const RequeteInfo({super.key});

  @override
  State<RequeteInfo> createState() => _RequeteInfoState();
}

enum requeteType {
  admin('Administratif', Icons.admin_panel_settings_outlined),
  tech('Technique', Icons.home_repair_service_outlined);

  const requeteType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class Request {
  final requeteType type;
  final String state;
  final String desc;
  final String title;
  final String firm;
  final DateTime date;
  Request({required this.title, required this.type, required this.state, required this.desc, required this.firm, required this.date});
  static const finished = "finish";
  static const waiting = "waiting";

  Map<String, dynamic> toMap() {
    return {
      'type': type.label,
      'state': state,
      'desc': desc,
      'firm': firm,
      'title': title,
      'date': date.toString(),
    };
  }
}


class _RequeteInfoState extends State<RequeteInfo> {
  final _titlecontroller = TextEditingController();
  final _desccontroller = TextEditingController();
  List<Request> requests = [];
  requeteType selectedType = requeteType.admin;
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final reqs = db.collection('request').where('firm', isEqualTo: user.email!.split('@')[1].split('.')[0]);
    reqs.get().then((value) {
      print(value.size);
      if(value.size == 0) return;
      setState(() {
        requests = value.docs.map<Request>((e) => Request(
            type: e['type'] == requeteType.admin.label ? requeteType.admin : requeteType.tech,
            state: e['state'],
            desc: e['desc'],
            title: e['title'],
            firm: e['firm'],
            date: DateTime.parse(e['date'])
        )).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wait = requests.where((element) => element.state == Request.waiting).toList();
    final finished = requests.where((element) => element.state == Request.finished).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(text: 'en attente'),
            Tab(text: 'clôturer',)
          ]),
          backgroundColor: Colors.white,
          title: const Text(
            "Les Requêtes",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Michroma',
              color: Colors.green,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                final request = await showDialog<Request>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, ss) => SingleChildScrollView(
                        child: Dialog(
                          insetPadding: const EdgeInsets.all(50),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *.9,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownMenu<requeteType>(
                                      initialSelection: requeteType.admin,
                                      dropdownMenuEntries: requeteType.values.map<DropdownMenuEntry<requeteType>>(
                                            (requeteType type) {
                                          return DropdownMenuEntry<requeteType>(
                                            value: type,
                                            label: type.label,
                                            leadingIcon: Icon(type.icon),
                                          );
                                        },
                                      ).toList(),
                                      onSelected: (requeteType? type) {
                                        ss(() {
                                          selectedType = type!;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 30,),
                                    TextField(
                                      controller: _titlecontroller,
                                      decoration: const InputDecoration(
                                          labelText: 'titre de la requete',
                                          labelStyle: TextStyle(fontSize: 20),
                                          prefixIcon: Icon(Icons.contact_support_outlined),
                                          border: OutlineInputBorder()

                                      ),
                                    ),
                                    const SizedBox(height: 30,),
                                    TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      minLines: 5,
                                      controller: _desccontroller,
                                      decoration: const InputDecoration(
                                          labelText: 'Description de la requete',
                                          labelStyle: TextStyle(fontSize: 20),
                                          border: OutlineInputBorder()

                                      ),
                                    ),
                                    const SizedBox(height: 30,),
                                    FilledButton(
                                        onPressed: () {
                                            if(_desccontroller.text == '') {
                                              return;
                                            }
                                            final user = FirebaseAuth.instance.currentUser!;
                                            final req = Request(
                                                title: _titlecontroller.text,
                                                type: selectedType,
                                                state: Request.waiting,
                                                desc: _desccontroller.text,
                                                firm:  user.email!.split('@')[1].split('.')[0],
                                                date: DateTime.now(),
                                            );
                                            Navigator.pop(context, req);
                                        },
                                        child: const Text("Envoyer une requete")
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );

                if(request != null) {
                  final db = FirebaseFirestore.instance;
                  final reqs = db.collection('request');
                  reqs.add(request.toMap());
                  setState(() {
                    requests.add(request);
                  });
                }

              },
              icon: const Icon(
                Icons.add,
                color: Colors.green,
                size: 35,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ListView.separated(
            itemCount: wait.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index)  {
              final request = wait[index];
              return ListTile(
                leading: Icon(request.type.icon, color: Colors.green.shade600,),
                contentPadding: const EdgeInsets.all(8.0),
                isThreeLine: true,
                subtitle: Text('${DateFormat('yyyy-MM-dd').format(request.date)} | ${request.type.label}', style: TextStyle(color: Colors.green.shade500),),
                title: Text(request.title,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                onTap: () {
          
                },
              );
            },
          ),
            ListView.separated(
              itemCount: finished.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index)  {
                final request = finished[index];
                return ListTile(
                  leading: Icon(request.type.icon, color: Colors.green.shade600,),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text('${DateFormat('yyyy-MM-dd').format(request.date)} | ${request.type.label}', style: TextStyle(color: Colors.green.shade500),),
                  title: Text(request.title,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  onTap: () {

                  },
                );
              },
            ),
          ]
        ),
      ),
    );
  }

}
