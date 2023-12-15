import 'package:flutter/material.dart';

class NoteReglementInfo extends StatefulWidget {
  const NoteReglementInfo({super.key});

  @override
  State<NoteReglementInfo> createState() => _NoteReglementInfoState();
}

class _NoteReglementInfoState extends State<NoteReglementInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Notes de Réglement",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}