import 'package:bhyapp/features/splash/presentation/widgets/all_informations/boncommande_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonlivraison_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonsortieinterne_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/demandeprix_inof.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/devis_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/factureadmin_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/notereglement_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/rapport_adminn.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/requete_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/lesengraishome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvriershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserLocal? user;

  @override
  void initState() {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    db.collection("users").doc(id).get().then((value) {
      setState(() {
        user = UserLocal(
          role: value.data()!["role"],
          firm: value.data()!["lieu de travail"],
          uid: id,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MenuCard(
              source: 'images/engrais.png',
              title: 'Les Engrais',
              child: EngraisHome(),
            ),
            const SizedBox(height: 20),
            const MenuCard(
              source: 'images/ImageOuvrier.png',
              title: 'Les Ouvriers',
              child: OuvrierHome(),
            ),
            const SizedBox(height: 20),
            user != null && user!.role != "admin"
                ? MenuCard(
                    source: 'images/rapport2.png',
                    title: 'Rapport Journalier',
                    child: RapportJournalier(user: user),
                  )
                : MenuCard(
                    source: 'images/rapport2.png',
                    title: 'Les Rapports Journaliers (Admin)',
                    child: RapportAdmin(user: user),
                  ),
            const SizedBox(height: 20),
            const MenuCard(
              source: 'images/bondesortie2.png',
              title: 'Bon de sortie interne',
              child: BonSortieInfo(),
            ),
            const SizedBox(height: 20),
            const MenuCard(
              source: 'images/facture.png',
              title: 'Factures',
              child: FactureInfo(),
            ),
            const SizedBox(height: 20),
            const MenuCard(
              source: 'images/requetes.png',
              title: 'Requêtes',
              child: RequeteInfo(),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const MenuCard(
                source: 'images/boncommande3.png',
                title: 'Bon de Commande',
                child: BonCommandeInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const MenuCard(
                source: 'images/bondelivraison3.png',
                title: 'Bon de Livraison',
                child: BonLivraisonInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const MenuCard(
                source: 'images/facture.png',
                title: 'Facture Administrative',
                child: FactureAdminInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const MenuCard(
                source: 'images/devis.png',
                title: 'Devis',
                child: DevisInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const MenuCard(
                source: 'images/demandeprix.png',
                title: "Demande d'offre de Prix",
                child: DemandePrixInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
                visible: isVisible(),
                child: const MenuCard(
                  source: 'images/notereglement.png',
                  title: 'Note de Règlement',
                  child: NoteReglementInfo(),
                )),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );*/
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 80),
        child: Center(
          child: Wrap(spacing: 20, runSpacing: 20, children: [
            const CustomCard(
              source: 'images/engrais3.jpg',
              title: 'Les Engrais',
              child: EngraisHome(),
            ),
            const SizedBox(height: 20),
            const CustomCard(
              source: 'images/ImageOuvrier.png',
              title: 'Les Ouvriers',
              child: OuvrierHome(),
            ),
            const SizedBox(height: 20),
            user != null && user!.role != "admin"
                ? CustomCard(
                    source: 'images/rapport.jpg',
                    title: 'Rapport Journalier',
                    child: RapportJournalier(user: user),
                  )
                : CustomCard(
                    source: 'images/rapport.jpg',
                    title: 'Les Rapports Journaliers',
                    child: RapportAdmin(user: user),
                  ),
            const SizedBox(height: 20),
            const CustomCard(
              source: 'images/bonsortie.jpg',
              title: 'Bon de sortie interne',
              child: BonSortieInfo(),
            ),
            const SizedBox(height: 20),
            const CustomCard(
              source: 'images/factureuser.jpg',
              title: 'Factures',
              child: FactureInfo(),
            ),
            const SizedBox(height: 20),
            const CustomCard(
              source: 'images/pic2.png',
              title: 'Requêtes',
              child: RequeteInfo(),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const CustomCard(
                source: 'images/boncommande.jpg',
                title: 'Bon de Commande',
                child: BonCommandeInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const CustomCard(
                source: 'images/bonlivraison.jpg',
                title: 'Bon de Livraison',
                child: BonLivraisonInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const CustomCard(
                source: 'images/factureadmin.jpg',
                title: 'Facture Administrative',
                child: FactureAdminInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const CustomCard(
                source: 'images/devis.webp',
                title: 'Devis',
                child: DevisInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isVisible(),
              child: const CustomCard(
                source: 'images/bourse.png',
                title: "Demande d'offre de Prix",
                child: DemandePrixInfo(),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
                visible: isVisible(),
                child: const CustomCard(
                  source: 'images/pic.png',
                  title: 'Note de Règlement',
                  child: NoteReglementInfo(),
                )),
            const SizedBox(height: 60),
          ]),
        ),
      ),
    );
  }

  bool isVisible() {
    return user != null && user!.role == "admin";
  }
}

class UserLocal {
  final String uid;
  final String role;
  final String firm;

  UserLocal({required this.uid, required this.role, required this.firm});
}

class CustomCard extends StatelessWidget {
  final String source;
  final Widget child;
  final String title;
  const CustomCard(
      {super.key,
      required this.child,
      required this.source,
      required this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => child),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        elevation: 5,
        child: Container(
          width: 300,
          height: 280,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  source,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
