// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _invalidCredentials = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("000000"),
          hexStringToColor("2d2b2e"),
          hexStringToColor("000000"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                child: Column(
                  children: <Widget>[
                    logoWidget("images/dumbell.png", 240, 240),
                    const SizedBox(
                      height: 120,
                    ),
                    reusableTextField("Enter Username", Icons.person_outline,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusablePasswordField(
                        "Enter Password", _passwordTextController),
                    _invalidCredentials
                        ? const Text("Invalid credentials, please retry.",
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    forgetPassword(context),
                    const SizedBox(
                      height: 20,
                    ),
                    button(context, 'LOG IN', () {
                      setState(() {
                        if (_passwordTextController.text != "123") {
                          _invalidCredentials = true;
                        } else {
                          _invalidCredentials = false;
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => homePage()));
                        }
                      });
                    }),
                    signUpOption(context),
                  ],
                ))),
      ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account? ",
          style: TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Padding forgetPassword(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgetPasswordScreen()));
          },
          child: const Text(
            "Forgotten Password?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}
