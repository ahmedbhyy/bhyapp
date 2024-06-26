import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:flutter/material.dart';

class Autres extends StatefulWidget {
  final String autres;
  final Future<void> Function(String) updatestate;
  final UserLocal? user;
  const Autres(
      {super.key, required this.autres, required this.updatestate, this.user});

  @override
  State<Autres> createState() => _AutresState();
}

class _AutresState extends State<Autres> {
  final TextEditingController _autredetaile = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _autredetaile.dispose();
  }

  @override
  void initState() {
    _autredetaile.text = widget.autres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Autres",
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              buildTextFieldWithEditIcon(
                hintText: "Détails",
                controller: _autredetaile,
              ),
              Visibility(
                visible: widget.user!.role != "admin",
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.updatestate(_autredetaile.text);
                    },
                    child: const Text('Enregistrer'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon(
      {required String hintText, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      enabled: widget.user!.role != "admin",
      style: const TextStyle(
        fontSize: 20.0,
      ),
      minLines: 5,
      maxLines: null,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
          )),
    );
  }
}
