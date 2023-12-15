import 'package:flutter/material.dart';

class DemandePrixInfo extends StatefulWidget {
  const DemandePrixInfo({super.key});

  @override
  State<DemandePrixInfo> createState() => _DemandePrixInfoState();
}

class _DemandePrixInfoState extends State<DemandePrixInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Les Demandes des Prix",
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
