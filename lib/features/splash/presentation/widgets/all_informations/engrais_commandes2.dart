import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:flutter/material.dart';

class ToutsCommandes extends StatefulWidget {
  final List<Engrai> panier;
  final Function(Engrai)? onDelete;
  final DateTime? date;
  const ToutsCommandes(
      {super.key, required this.panier, this.onDelete, this.date});

  @override
  State<ToutsCommandes> createState() => _ToutsCommandesState();
}

class _ToutsCommandesState extends State<ToutsCommandes> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.onDelete == null
          ? null
          : FilledButton.icon(
              onPressed: widget.panier.isEmpty
                  ? null
                  : () {
                      Navigator.pop(context, true);
                    },
              label: const Text("envoyer la commande"),
              icon: const Icon(Icons.attach_money)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "commandes",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
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
              itemCount: widget.panier.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final engrai = widget.panier[index];
                return ListTile(
                  leading: Icon(
                    Icons.payments,
                    color: Colors.green.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  isThreeLine: true,
                  subtitle: Text(
                    "prix de vente: ${engrai.priv}\nprix d'achat: ${engrai.pria}\nquantité: ${engrai.quantity}",
                    style: TextStyle(color: Colors.green.shade500),
                  ),
                  title: Text(engrai.name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  trailing: Visibility(
                    visible: widget.onDelete != null,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Confirm Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to delete this item?',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    widget.onDelete!(engrai);
                                  });
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
