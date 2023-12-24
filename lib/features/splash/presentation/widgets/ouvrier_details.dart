import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_conges.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_deplacement.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_heures.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_prime.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvrier_voyage_diesel.dart';
import 'package:flutter/material.dart';

class OuvrierDetails extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Ouvriername;
  final String id;

  // ignore: non_constant_identifier_names
  const OuvrierDetails({Key? key, required this.Ouvriername, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OuvrierDetails createState() => _OuvrierDetails();
}

class _OuvrierDetails extends State<OuvrierDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.Ouvriername,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Michroma',
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OuvrierPrime(id: widget.id)),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Prime',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.green),
                      ),
                      SizedBox(width: 215),
                      Icon(Icons.euro),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CongesOuvrier(id: widget.id)),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Congés de Travail',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.green),
                      ),
                      SizedBox(width: 92),
                      Icon(Icons.view_timeline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OuvrierHeure(id: widget.id)),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Heures Supplémentaires',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.green),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.more_time),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OuvrierVoyageDiesel(
                                id: widget.id,
                              )),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Voyages et Diesel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.green),
                      ),
                      SizedBox(width: 90),
                      Icon(Icons.oil_barrel),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OuvrierDeplacement(
                                id: widget.id,
                              )),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Déplacament',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.green),
                      ),
                      SizedBox(width: 135),
                      Icon(Icons.local_shipping),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
