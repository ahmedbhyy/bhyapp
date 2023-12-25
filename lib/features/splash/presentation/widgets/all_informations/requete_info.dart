import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../homepage.dart';
import 'package:http/http.dart' as http;

class RequeteInfo extends StatefulWidget {
  final UserLocal? user;
  const RequeteInfo({super.key, this.user});

  @override
  State<RequeteInfo> createState() => _RequeteInfoState();
}

enum RequeteType {
  admin('Administratif', Icons.admin_panel_settings_outlined),
  tech('Technique', Icons.home_repair_service_outlined);

  const RequeteType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class Request {
  final RequeteType type;
  final String state;
  final String desc;
  final String id;
  final String response;
  final String title;
  final String firm;
  final DateTime date;
  Request(
      {required this.title,
      required this.type,
      required this.response,
      required this.state,
      required this.desc,
      required this.firm,
      required this.id,
      required this.date});
  static const finished = "finish";
  static const waiting = "waiting";

  Map<String, dynamic> toMap() {
    return {
      'type': type.label,
      'state': state,
      'desc': desc,
      'firm': firm,
      'title': title,
      'response': response,
      'date': date.toString(),
    };
  }
}

class _RequeteInfoState extends State<RequeteInfo> {
  final _titlecontroller = TextEditingController();
  final _desccontroller = TextEditingController();
  List<Request> requests = [];
  RequeteType selectedType = RequeteType.admin;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final db = FirebaseFirestore.instance;
    final reqs = db.collection('request');
    final docs = widget.user!.role == "admin"
        ? reqs
        : reqs.where('firm', isEqualTo: widget.user!.firm);
    docs.get().then((value) {
      if (value.size == 0) return;
      setState(() {
        requests = value.docs
            .map<Request>((e) => Request(
                type: e['type'] == RequeteType.admin.label
                    ? RequeteType.admin
                    : RequeteType.tech,
                state: e['state'],
                desc: e['desc'],
                title: e['title'],
                firm: e['firm'],
                response: e['response'],
                id: e.id,
                date: DateTime.parse(e['date'])))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wait =
        requests.where((element) => element.state == Request.waiting).toList();
    final finished =
        requests.where((element) => element.state == Request.finished).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(text: 'en attente'),
            Tab(
              text: 'clôturer',
            )
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
            Visibility(
              visible: widget.user!.role != "admin",
              child: IconButton(
                onPressed: () async {
                  final request = await showDialog<Request>(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, ss) => SingleChildScrollView(
                          child: Dialog(
                            insetPadding: const EdgeInsets.all(50),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .9,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      DropdownMenu<RequeteType>(
                                        initialSelection: RequeteType.admin,
                                        dropdownMenuEntries: RequeteType.values
                                            .map<
                                                DropdownMenuEntry<RequeteType>>(
                                          (RequeteType type) {
                                            return DropdownMenuEntry<
                                                RequeteType>(
                                              value: type,
                                              label: type.label,
                                              leadingIcon: Icon(type.icon),
                                            );
                                          },
                                        ).toList(),
                                        onSelected: (RequeteType? type) {
                                          ss(() {
                                            selectedType = type!;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      TextField(
                                        controller: _titlecontroller,
                                        decoration: const InputDecoration(
                                            labelText: 'titre de la requête',
                                            labelStyle: TextStyle(fontSize: 20),
                                            prefixIcon: Icon(
                                                Icons.contact_support_outlined),
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        minLines: 5,
                                        controller: _desccontroller,
                                        decoration: const InputDecoration(
                                            labelText:
                                                'Description de la requête',
                                            labelStyle: TextStyle(fontSize: 20),
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      FilledButton(
                                          onPressed: () {
                                            if (_desccontroller.text == '') {
                                              return;
                                            }
                                            var req = Request(
                                              title: _titlecontroller.text,
                                              type: selectedType,
                                              state: Request.waiting,
                                              desc: _desccontroller.text,
                                              firm: widget.user!.firm,
                                              response: '',
                                              id: DateTime.now().toString(),
                                              date: DateTime.now(),
                                            );
                                            Navigator.pop(context, req);
                                          },
                                          child:
                                              const Text("Envoyer une requête"))
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

                  if (request != null) {
                    final db = FirebaseFirestore.instance;
                    final reqs = db.collection('request').doc(request.id);
                    reqs.set(request.toMap(), SetOptions(merge: true));
                    setState(() {
                      requests.add(request);
                    });

                    final body = jsonEncode(<String, dynamic>{
                      'app_id': '19ca5fd9-1a46-413f-9209-d77a7d63dde0',
                      'contents': {
                        "en":
                            "vous avez reçu une nouvelle requete ${request.type.label} de ${request.firm}"
                      },
                      'filters': [
                        {
                          "field": "tag",
                          "key": "role",
                          "relation": "=",
                          "value": "admin"
                        }
                      ]
                    });
                    await http.post(
                      Uri.parse('https://onesignal.com/api/v1/notifications'),
                      body: body,
                      headers: {
                        'Content-Type': "application/json",
                        HttpHeaders.authorizationHeader:
                            'Basic YmU0YTUwODktOGIxZC00MTIwLTkyY2UtOWVkZTg1NTYyZWZj',
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.green,
                  size: Platform.isAndroid ? 24 : 45,
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(children: [
          ListView.separated(
            itemCount: wait.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return CustomTile(
                request: wait[index],
                user: widget.user!,
                onchange: (reqMap) {
                  setState(() {
                    final ii = requests.indexOf(wait[index]);
                    requests[ii] = Request(
                      id: wait[index].id,
                      firm: wait[index].firm,
                      date: wait[index].date,
                      desc: wait[index].desc,
                      type: wait[index].type,
                      response: reqMap["response"],
                      state: Request.finished,
                      title: wait[index].title,
                    );
                  });
                },
              );
            },
          ),
          ListView.separated(
            itemCount: finished.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return CustomTile(
                request: finished[index],
                user: widget.user!,
                onchange: (_) {},
              );
            },
          ),
        ]),
      ),
    );
  }
}

class CustomTile extends StatefulWidget {
  final Request request;
  final UserLocal user;
  final void Function(Map<String, dynamic>) onchange;
  const CustomTile(
      {super.key,
      required this.request,
      required this.user,
      required this.onchange});

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  double _height = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              widget.request.type.icon,
              color: Colors.green.shade600,
            ),
            contentPadding: const EdgeInsets.all(8.0),
            isThreeLine: true,
            subtitle: Text(
              '${DateFormat('yyyy-MM-dd').format(widget.request.date)} | ${widget.request.type.label} | ${widget.request.firm}',
              style: TextStyle(color: Colors.green.shade500),
            ),
            title: Text(widget.request.title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            onTap: () {
              setState(() {
                _height = 250 - _height;
              });
            },
            trailing: widget.user.role != "admin" ||
                    widget.request.state == Request.finished
                ? null
                : FilledButton.icon(
                    onPressed: () async {
                      final res = await showModalBottomSheet<String>(
                        context: context,
                        builder: (context) {
                          return MyBottomSheet(request: widget.request);
                        },
                        showDragHandle: true,
                        scrollControlDisabledMaxHeightRatio: .8,
                      );
                      if (res == null) return;
                      if (res.isEmpty) return;

                      final db = FirebaseFirestore.instance;
                      final reqs =
                          db.collection('request').doc(widget.request.id);
                      var nreqmap = widget.request.toMap();
                      nreqmap["response"] = res;
                      nreqmap["state"] = Request.finished;
                      reqs.set(nreqmap, SetOptions(merge: true));
                      setState(() {
                        widget.onchange(nreqmap);
                      });
                      final body = jsonEncode(<String, dynamic>{
                        'app_id': '19ca5fd9-1a46-413f-9209-d77a7d63dde0',
                        'contents': {
                          "en":
                              "Vous avez recu une réponse pour votre requête ${widget.request.title}"
                        },
                        'filters': [
                          {
                            "field": "tag",
                            "key": "firme",
                            "relation": "=",
                            "value": widget.request.firm
                          }
                        ]
                      });
                       await http.post(
                        Uri.parse('https://onesignal.com/api/v1/notifications'),
                        body: body,
                        headers: {
                          'Content-Type': "application/json",
                          HttpHeaders.authorizationHeader:
                              'Basic YmU0YTUwODktOGIxZC00MTIwLTkyY2UtOWVkZTg1NTYyZWZj',
                        },
                      );
                    },
                    icon: const Icon(Icons.subdirectory_arrow_left_outlined),
                    label: const Text("répondre")),
          ),
          AnimatedContainer(
              height: _height,
              duration: const Duration(milliseconds: 250),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "${widget.request.desc}\n\n\n${widget.request.state == Request.finished ? 'Réponse:\n${widget.request.response}' : ''}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 19),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  final Request request;
  const MyBottomSheet({super.key, required this.request});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.request.title,
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    )),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  onSubmitted: (val) {},
                  controller: controller,
                  maxLines: null,
                  minLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("réponse"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            FilledButton(
                onPressed: () {
                  final tmp = controller.text;
                  Navigator.pop(context, tmp);
                },
                child: const Center(child: Text("Répondre")))
          ],
        ),
      ),
    );
  }
}
