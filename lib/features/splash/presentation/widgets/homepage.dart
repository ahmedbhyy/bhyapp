import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/admin_devis.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/bon_de_commande.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/bon_de_livraison.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/demande_prix.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/facture_administrative.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/note_reglement.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/boncommande_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonlivraison_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonsortieinterne_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/demandeprix_inof.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/devis_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/factureadmin_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/notereglement_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/requete_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/bon_sortie.dart';
import 'package:bhyapp/features/splash/presentation/widgets/facture.dart';
import 'package:bhyapp/features/splash/presentation/widgets/lesengraishome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvriershome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/profile_screen.dart';
import 'package:bhyapp/features/splash/presentation/widgets/requetes.dart';
import 'package:bhyapp/features/splash/presentation/widgets/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String> roles = {'m@g.me': 'admin', 'ahmed@bhy.me': 'user'};
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EngraisHome(date: date)),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/engrais.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Les Engrais',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OuvrierHome()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/ImageOuvrier.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Les Ouvriers',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RapportJournalier()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/rapport2.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rapport Journalier',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BonSortieInfo()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/bondesortie2.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Bon de sortie interne',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FactureInfo()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/facture.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Factures',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RequeteInfo()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'images/requetes.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Requêtes',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BonCommandeInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/boncommande3.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Bon de Commande',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BonLivraisonInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/bondelivraison3.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Bon de Livraison',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FactureAdminInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/facture.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Facture Administrative',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DevisInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/devis.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Devis',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DemandePrixInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/demandeprix.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Demande d\'offre de Prix',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: roles[widget.email] == "admin",
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoteReglementInfo()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/notereglement.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Note de Règlement',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
