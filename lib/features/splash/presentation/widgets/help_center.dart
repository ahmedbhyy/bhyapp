import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help Center",
          style: TextStyle(
              fontFamily: 'Michroma',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Contact Us by email : Ahmed.belhajyahia213@gmail.com',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
