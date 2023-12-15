import 'package:flutter/material.dart';

class BonCommandeInfo extends StatefulWidget {
  const BonCommandeInfo({super.key});

  @override
  State<BonCommandeInfo> createState() => _BonCommandeInfoState();
}

class _BonCommandeInfoState extends State<BonCommandeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Commande",
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
