import 'package:flutter/material.dart';

class DevisInfo extends StatefulWidget {
  const DevisInfo({super.key});

  @override
  State<DevisInfo> createState() => _DevisInfoState();
}

class _DevisInfoState extends State<DevisInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Devis",
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