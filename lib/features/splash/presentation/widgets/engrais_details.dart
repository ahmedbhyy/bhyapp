import 'package:bhyapp/features/splash/presentation/widgets/engrais_commandes.dart';
import 'package:flutter/material.dart';

class EngraisDetails extends StatefulWidget {
  final String engraisName;

  const EngraisDetails({Key? key, required this.engraisName}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EngraisDetailsState createState() => _EngraisDetailsState();
}

class _EngraisDetailsState extends State<EngraisDetails> {
  final TextEditingController _achatController = TextEditingController();
  final TextEditingController _venteController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();

  @override
  void dispose() {
    _achatController.dispose();
    _venteController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.engraisName,
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
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Prix de Vente",
              controller: _venteController,
            ),
            const SizedBox(height: 20),
            buildTextFieldWithEditIcon(
              hintText: "Quantités",
              controller: _quantiteController,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Commandes()),
                );
              },
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Commandes()),
                );
              },
              child: const Text('Les Commandes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithEditIcon(
      {required String hintText, required TextEditingController controller}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 20.0),
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              hintText: hintText,
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
