import 'package:bhyapp/features/splash/presentation/widgets/about_us.dart';
import 'package:bhyapp/features/splash/presentation/widgets/help_center.dart';
import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  String? username;
  void _navigateBottomBar(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    username = FirebaseAuth.instance.currentUser?.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'images/background2.png', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('images/logoprofile.png'),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    username as String,
                    style: TextStyle(
                      fontFamily: 'Michroma',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5f0f40),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUs(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0x0042D351), // Background color of the button
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF191919)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Container(
                      width: 300,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'About Us',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Michroma',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 4.08,
                            ),
                          ),
                          SizedBox(width: 120),
                          Icon(
                            Icons.panorama_photosphere,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Settings(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x0042D351),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF191919)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Container(
                      width: 300,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Michroma',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 4.08,
                            ),
                          ),
                          SizedBox(width: 120),
                          Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpCenter(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x0042D351),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF191919)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Container(
                      width: 300,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Help Center',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Michroma',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 4.08,
                            ),
                          ),
                          SizedBox(width: 70),
                          Icon(
                            Icons.help,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: Colors.white,
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
              Icons.message,
              color: Colors.black,
            ),
            Icon(
              Icons.person,
              color: Colors.black,
            ),
          ]),
    );
  }
}
