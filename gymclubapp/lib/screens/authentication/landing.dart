// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      log("${user.email} is already signed in.");
      return HomeScreen(userUID: user.uid);
    } else {
      log("No user is signed in.");
      return const SignInScreen();
    }
    //   return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.active) {
    //         User? user = snapshot.data;
    //         if (user != null && user.emailVerified) {
    //           print("${user.email} is already logged in!");
    //           return HomeScreen(userUID: user.uid);
    //         } else {
    //           return const SignInScreen();
    //         }
    //       } else {
    //         return const Scaffold(
    //           backgroundColor: Colors.black,
    //           body: Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.white,
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   );
    // }
  }
}
