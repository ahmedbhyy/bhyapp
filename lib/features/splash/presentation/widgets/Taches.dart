// ignore: file_names
import 'package:flutter/material.dart';

class Taches extends StatefulWidget {
  const Taches({super.key});

  @override
  State<Taches> createState() => _TachesState();
}

class _TachesState extends State<Taches> {
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
    );
  }
}
