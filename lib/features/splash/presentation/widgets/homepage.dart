import 'dart:io';

import 'package:bhyapp/features/splash/presentation/widgets/all_informations/boncommande_info%20copy.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/boncommande_info.dart';

import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonsortieinterne_info%20copy.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/bonsortieinterne_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info%20copy.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/facture_info.dart';

import 'package:bhyapp/features/splash/presentation/widgets/all_informations/notereglement_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/rapport_adminn.dart';
import 'package:bhyapp/features/splash/presentation/widgets/all_informations/requete_info.dart';
import 'package:bhyapp/features/splash/presentation/widgets/lesengraishome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvriershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
    db.collection("users").doc(id).get().then((value) async {
      if (Platform.isAndroid) {
        await OneSignal.login(id);
        OneSignal.User.addTagWithKey("role", value.data()!["role"]);
        OneSignal.User.addTagWithKey("firme", value.data()!["lieu de travail"]);
      }
      setState(() {
        user = UserLocal(
          role: value.data()!["role"],
          firm: value.data()!["lieu de travail"],
          name: value.data()!["nom et prenom"],
          uid: id,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 30),
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              CustomCard(
                source: 'images/engrais3.jpg',
                title: 'Les Engrais',
                child: EngraisHome(user: user),
              ),
              const CustomCard(
                source: 'images/ImageOuvrier.png',
                title: 'Les Ouvriers',
                child: OuvrierHome(),
              ),
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
              CustomCard(
                source: 'images/bonsortie.jpg',
                title: 'Bon de sortie interne',
                child: BonSortieInfo(user: user),
              ),
              CustomCard(
                source: 'images/factureuser.jpg',
                title: 'Factures',
                child: FactureInfo(user: user),
              ),
              Visibility(
                visible: Platform.isAndroid,
                child: Center(
                  child: CustomCard(
                    source: 'images/pic2.png',
                    title: 'Requêtes',
                    child: RequeteInfo(user: user),
                  ),
                ),
              ),
              Visibility(
                visible: !Platform.isAndroid,
                child: CustomCard(
                  source: 'images/pic2.png',
                  title: 'Requêtes',
                  child: RequeteInfo(user: user),
                ),
              ),
              Visibility(
                visible: isVisible(),
                child: const CustomCard(
                  source: 'images/boncommande.jpg',
                  title: 'Bon de Commande',
                  child: BonCommandeInfo(),
                ),
              ),
              Visibility(
                visible: isVisible(),
                child: CustomCard(
                  source: 'images/bonlivraison.jpg',
                  title: 'Bon de Livraison',
                  child: BonLivraisonInfo2(user: user),
                ),
              ),
              Visibility(
                visible: isVisible(),
                child: CustomCard(
                  source: 'images/factureadmin.jpg',
                  title: 'Facture Administrative',
                  child: FactureInfo(
                    admin: true,
                    user: user,
                  ),
                ),
              ),
              Visibility(
                visible: isVisible(),
                child: CustomCard(
                  source: 'images/devis.webp',
                  title: 'Devis',
                  child: Devisinfo2(user: user),
                ),
              ),
              Visibility(
                visible: isVisible(),
                child: const CustomCard(
                  source: 'images/bourse.png',
                  title: "Demande d'offre de Prix",
                  child: DemandePrix2(),
                ),
              ),
              Visibility(
                  visible: isVisible(),
                  child: const CustomCard(
                    source: 'images/pic.png',
                    title: 'Note de Règlement',
                    child: NoteReglementInfo(),
                  )),
            ]),
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
  final String name;

  UserLocal(
      {required this.uid,
      required this.role,
      required this.firm,
      required this.name});
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
