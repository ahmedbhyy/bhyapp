import 'package:bhyapp/les%20engrais/engrais_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EngraisDetails extends StatefulWidget {
  final Engrai engrai;
  final List<Engrai> panier;
  const EngraisDetails({Key? key, required this.engrai, required this.panier})
      : super(key: key);

  @override
  EngraisDetailsState createState() => EngraisDetailsState();
}

class EngraisDetailsState extends State<EngraisDetails> {
  final TextEditingController _achatController = TextEditingController();
  final TextEditingController _venteController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  bool _isLoading = true;

  @override
  void dispose() {
    _achatController.dispose();
    _venteController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      final eng = widget.engrai;
      _venteController.text = eng.priv.toString();
      _achatController.text = eng.pria.toString();
      _quantiteController.text = eng.quantity.toString();
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.engrai.name,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Michroma',
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildTextFieldWithEditIcon(
              hintText: "Prix d'Achat",
              controller: _achatController,
              suffixText: 'DT',
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Prix de Vente",
              controller: _venteController,
              suffixText: 'DT',
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
                hintText: "Quantités",
                controller: _quantiteController,
                suffixText: ''),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                final prixa = double.parse(_achatController.value.text);
                final prixv = double.parse(_venteController.value.text);
                final quantite = int.parse(_quantiteController.value.text);

                final db = FirebaseFirestore.instance;
                final details = db.collection("engrais").doc(widget.engrai.id);

                details.update(
                    {'priv': prixv, 'pria': prixa, 'quantity': quantite});
                Navigator.pop(context, {
                  "panier": false,
                  "engrai": Engrai(
                    quantity: quantite,
                    priv: prixv,
                    pria: prixa,
                    name: widget.engrai.name,
                    url: widget.engrai.url,
                    id: widget.engrai.id,
                  )
                });
              },
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: widget.panier.any((e) => e.id == widget.engrai.id)
                  ? null
                  : () {
                      final prixa = double.parse(_achatController.value.text);
                      final prixv = double.parse(_venteController.value.text);
                      final quantite =
                          int.parse(_quantiteController.value.text);
                      Navigator.pop(context, {
                        "panier": true,
                        "engrai": Engrai(
                          quantity: quantite,
                          priv: prixv,
                          pria: prixa,
                          name: widget.engrai.name,
                          url: widget.engrai.url,
                          id: widget.engrai.id,
                        )
                      });
                    },
              child: Text(widget.panier.any((e) => e.id == widget.engrai.id)
                  ? 'dans le panier'
                  : 'ajouter au panier'),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon({
    required String hintText,
    required TextEditingController controller,
    required String suffixText,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              labelText: hintText,
              suffixText: suffixText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFC2BCBC)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
