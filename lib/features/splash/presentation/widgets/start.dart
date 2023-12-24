import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/profile_screen.dart';
import 'package:bhyapp/features/splash/presentation/widgets/weather.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 0;
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
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ClipOval(
                    child: Image.asset(
                      'images/logo baraka.PNG',
                      fit: BoxFit.cover,
                      width: 45,
                      height: 45,
                    ),
                  ),
                ],
              ),
            )
          : null,
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
    if (_selectedIndex == 0) return HomePage();
    if (_selectedIndex == 1) return WeatherPage();
    if (_selectedIndex == 2) return const ProfileScreen();
  }
}
