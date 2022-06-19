// ignore_for_file: library_private_types_in_public_api, unused_import, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: signUpForm(
                  context,
                  _usernameTextController,
                  _emailTextController,
                  _passwordTextController,
                  _confirmPasswordTextController,
                  signUpMethod)),
        ),
      ),
    );
  }

// Sign Up Method
  Future<void> signUpMethod(
      BuildContext context,
      TextEditingController emailTextController,
      TextEditingController passwordTextController) async {
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);

      final user = credentials.user;
      await user?.sendEmailVerification().then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const SignInScreen())));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else {
        print('The account aleady exists for the email.');
      }
    } catch (e) {
      print(e);
    }
  }
}

// Sign Up Form Widget
Column signUpForm(
    BuildContext context,
    TextEditingController usernameTextController,
    TextEditingController emailTextController,
    TextEditingController passwordTextController,
    TextEditingController confirmPasswordTextController,
    Function signUpFunction) {
  return Column(
    children: <Widget>[
      logoWidget("images/dumbell.png", 120, 120),
      const SizedBox(
        height: 20,
      ),
      reusableTextField(
          "Enter Username", Icons.person_outline, usernameTextController),
      const SizedBox(
        height: 20,
      ),
      reusableTextField(
        "Enter Email Address",
        Icons.email_outlined,
        emailTextController,
      ),
      const SizedBox(
        height: 20,
      ),
      reusablePasswordField(
        "Enter Password",
        passwordTextController,
      ),
      const SizedBox(
        height: 20,
      ),
      reusablePasswordField(
        "Confirm Password",
        confirmPasswordTextController,
      ),
      const SizedBox(
        height: 20,
      ),
      button(context, 'SIGN UP', () async {
        await signUpFunction(
            context, emailTextController, passwordTextController);
      }),
    ],
  );
}
