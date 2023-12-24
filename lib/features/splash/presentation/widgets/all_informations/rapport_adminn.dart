import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RapportAdmin extends StatefulWidget {
  final UserLocal? user;
  const RapportAdmin({super.key, this.user});

  @override
  State<RapportAdmin> createState() => _RapportAdminState();
}

class _RapportAdminState extends State<RapportAdmin> {
  final TextEditingController _lieufirme = TextEditingController();
  TextEditingController get controller => _lieufirme;

  List<String> firmes = [];

  @override
  void initState() {
    _getfirmes();
    super.initState();
  }

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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: firmes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final firme = firmes[index];
                return ListTile(
                  leading: Icon(
                    Icons.place,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  title: Text(firme,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  subtitle: const Text(""),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RapportJournalier(
                                  user: UserLocal(
                                      firm: firme,
                                      role: widget.user!.role,
                                      uid: widget.user!.uid,
                                      name: widget.user!.name,
                                  ),
                                )));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getfirmes() async {
    final db = await FirebaseFirestore.instance.collection("firmes").get();
    setState(() {
      firmes = db.docs.map((e) => e.id).toList();
    });
  }
}
