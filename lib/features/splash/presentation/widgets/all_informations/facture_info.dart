import 'package:flutter/material.dart';

class FactureInfo extends StatefulWidget {
  const FactureInfo({super.key});

  @override
  State<FactureInfo> createState() => _FactureInfoState();
}

class _FactureInfoState extends State<FactureInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Factures",
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