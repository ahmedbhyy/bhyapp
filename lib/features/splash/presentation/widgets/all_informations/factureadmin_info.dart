import 'package:flutter/material.dart';

class FactureAdminInfo extends StatefulWidget {
  const FactureAdminInfo({super.key});

  @override
  State<FactureAdminInfo> createState() => _FactureAdminInfoState();
}

class _FactureAdminInfoState extends State<FactureAdminInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Facture d'Admin",
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