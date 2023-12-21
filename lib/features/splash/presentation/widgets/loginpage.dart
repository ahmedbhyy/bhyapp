import 'package:bhyapp/features/splash/presentation/widgets/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool _isLoading = false;
  Future<bool> checkCredentials(String enteredUsername, String enteredPassword) async {
    setState(() {
      _isLoading = true; 
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: enteredUsername, password: enteredPassword);
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
      String enteredUsername = usernameController.text;
      String enteredPassword = passwordController.text;

      if (await checkCredentials(enteredUsername, enteredPassword)) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StartPage(
                    email: enteredUsername,
                  )),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('email ou mot de passe invalide !'),
          ),
        );
      }
   
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
                    child: SizedBox(
                      height: 200,
                      child: Image.asset("images/logo baraka.PNG"),
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
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: usernameController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        hintText: 'donner votre email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0),
                  Container(
                    width: 300,
                    height: 45,
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
                        hintText: 'donner votre mot de passe',
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
                        width: 150,
                        height: 40,
                        alignment: Alignment.center,
                        child: const Text(
                          'sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Michroma',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
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
