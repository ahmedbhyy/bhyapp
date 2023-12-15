import 'package:flutter/material.dart';

class BonSortieInfo extends StatefulWidget {
  const BonSortieInfo({super.key});

  @override
  State<BonSortieInfo> createState() => _BonSortieInfoState();
}

class _BonSortieInfoState extends State<BonSortieInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Bons de Sorties interne",
          style: TextStyle(
            fontSize: 18.3,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
