import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OuvrierPrime extends StatefulWidget {
  const OuvrierPrime({super.key});

  @override
  State<OuvrierPrime> createState() => _OuvrierPrimeState();
}


class _OuvrierPrimeState extends State<OuvrierPrime> {
  List<Prime> primes = [Prime(date: DateTime.now(), montant: 250.5)];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: const Icon(Icons.add),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text(
          "Prime",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: primes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index)  {
                final prime = primes[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(prime.montant.toString()),
                  title: Text("Prime de ${DateFormat('yyyy-MM-dd').format(prime.date)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Prime {
  final double montant;
  final DateTime date;

  Prime({required this.montant, required this.date});
}