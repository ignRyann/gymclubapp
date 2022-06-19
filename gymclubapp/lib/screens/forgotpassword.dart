// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gymclubapp/utils/utils.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _resetCredsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // [Widget] Sign Out Elevated Button
    final recoverAccount = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'RECOVER ACCOUNT',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("images/dumbell.png", 120, 120),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField('Enter Username/Email Address',
                    Icons.person_outline, _resetCredsController),
                const SizedBox(
                  height: 20,
                ),
                recoverAccount
              ],
            ),
          ),
        ),
      ),
    );
  }
}
