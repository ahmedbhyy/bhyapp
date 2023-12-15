import 'package:flutter/material.dart';

class BonLivraisonInfo extends StatefulWidget {
  const BonLivraisonInfo({super.key});

  @override
  State<BonLivraisonInfo> createState() => _BonLivraisonInfoState();
}

class _BonLivraisonInfoState extends State<BonLivraisonInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Livraison",
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
