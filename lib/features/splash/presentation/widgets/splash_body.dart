import 'package:bhyapp/features/splash/presentation/widgets/loginpage.dart';
import 'package:flutter/material.dart';

class SplashBody extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const SplashBody({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/farm2.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 200,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              height: 220,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Al Baraka',
                style: TextStyle(
                  fontFamily: 'Michroma',
                  fontSize: 51,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7f4f24),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 180),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x0042D351),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF191919)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                width: 300,
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Michroma',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4.08,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
