import 'package:flutter/material.dart';

class RequeteInfo extends StatefulWidget {
  const RequeteInfo({super.key});

  @override
  State<RequeteInfo> createState() => _RequeteInfoState();
}

class _RequeteInfoState extends State<RequeteInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Requêtes",
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
