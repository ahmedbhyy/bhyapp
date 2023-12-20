import 'package:bhyapp/features/splash/presentation/widgets/homepage.dart';
import 'package:bhyapp/features/splash/presentation/widgets/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool _isLoading = false;
  Future<bool> checkCredentials(
      String enteredUsername, String enteredPassword) async {
    setState(() {
      _isLoading =
          true; // Set loading state to true when starting authentication
    });
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: enteredUsername, password: enteredPassword);

      print("logged in with user !");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return false; // Authentication failed
  }

  // Function for handling the login button press
  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      TextInput.finishAutofillContext();
      // Submit form
    }
    String enteredUsername = usernameController.text;
    String enteredPassword = passwordController.text;

    if (await checkCredentials(enteredUsername, enteredPassword)) {
      // Navigate to the home page if authentication is successful
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(
            builder: (context) => StartPage(
                  email: enteredUsername,
                )),
      );
    } else {
      // Show an error message or handle unsuccessful login
      // For simplicity, show a snackbar with an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/firm2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 140),
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: AssetImage("images/logo baraka.PNG"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 10),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'Michroma',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6a040f),
                      ),
                    ),
                  ),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF6a040f)),
                        ))
                      : Container(),
                  const SizedBox(height: 60.0),
                  Container(
                    width: 300,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: usernameController,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        hintText: 'Enter your username',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0),
                  Container(
                    width: 300,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: passwordController,
                      autofillHints: const [AutofillHints.password],
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          child: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 10),
                    child: ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF9233),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: 250,
                        height: 40,
                        alignment: Alignment.center,
                        child: const Text(
                          'Sign In',
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
            ),
          ),
        ),
      ),
    );
  }
}
