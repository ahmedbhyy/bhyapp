import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/admin_devis.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/bon_de_commande.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/bon_de_livraison.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/demande_prix.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/facture_administrative.dart';
import 'package:bhyapp/features/splash/presentation/widgets/adminscreens/note_reglement.dart';
import 'package:bhyapp/features/splash/presentation/widgets/bon_sortie.dart';
import 'package:bhyapp/features/splash/presentation/widgets/facture.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/lesengraishome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/rapport.dart';
import 'package:bhyapp/features/splash/presentation/widgets/ouvriershome.dart';
import 'package:bhyapp/features/splash/presentation/widgets/profile_screen.dart';
import 'package:bhyapp/features/splash/presentation/widgets/requetes.dart';
import 'package:bhyapp/features/splash/presentation/widgets/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  final String email;
  const StartPage({Key? key, required this.email}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  int _selectedIndex = 0;
  final Map<String, String> roles = {
    'm@g.me': 'admin',
    'test@test.com': 'user'
  };
  void _navigateBottomBar(int index) {
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                'Al Baraka',
                style: TextStyle(
                  fontFamily: 'Michroma',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 165),
                child: ClipOval(
                  child: Image.asset(
                    'images/logo baraka.PNG',
                    fit: BoxFit.cover,
                    width: 45, // Adjust the width as needed
                    height: 45, // Adjust the height as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _generateWindow(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.transparent,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _navigateBottomBar,
        index: _selectedIndex,
        items: const [
          Icon(
            Icons.home,
            color: Colors.black,
          ),
          Icon(
            Icons.wb_sunny,
            color: Colors.black,
          ),
          Icon(
            Icons.person,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  _generateWindow(int selectedIndex) {
    if(_selectedIndex == 0) return HomePage(email:widget.email);
    if(_selectedIndex == 1) return WeatherPage();
    if(_selectedIndex == 2) return ProfileScreen();
  }
}
