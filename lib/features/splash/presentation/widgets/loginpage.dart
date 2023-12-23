import 'package:bhyapp/features/splash/presentation/widgets/edit_profile.dart';
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

  Future<bool> checkCredentials(
      String enteredUsername, String enteredPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: enteredUsername, password: enteredPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
    }

    return false;
  }

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String enteredUsername = usernameController.text;
      String enteredPassword = passwordController.text;

      if (await checkCredentials(enteredUsername, enteredPassword)) {
        TextInput.finishAutofillContext();
        // ignore: use_build_context_synchronously
        if (FirebaseAuth.instance.currentUser!.displayName == null) {
          final go = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => const Settings(),
              ));
          if (go != null && go) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartPage(),
                ));
          }
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StartPage(),
              ));
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('email ou mot de passe invalide !'),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: AssetImage("images/logo baraka.PNG"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      height: 220,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 10),
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
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        hintText: 'adresse e-mail',
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
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      autofillHints: const [AutofillHints.password],
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: 'mot de passe',
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
                  const SizedBox(
                    height: 60,
                  ),
                  FilledButton(
                      onPressed: handleLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xffFF9233),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 5),
                      ),
                      child: const Text(
                        'sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Michroma',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
