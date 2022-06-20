// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
// Firebase Imports
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    // User Signed In ? HomeScreen() : SignInScreen()
    if (authenticated(auth)) {
      return const MaterialApp(
        title: 'GymClub',
        home: HomeScreen(),
      );
    } else {
      return const MaterialApp(
        title: 'GymClub',
        home: SignInScreen(),
      );
    }
  }

  // User Signed In & Verified Method
  bool authenticated(FirebaseAuth auth) {
    bool authenticated = false;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print("No User");
        authenticated = false;
      } else {
        if (user.emailVerified) {
          print("User verified");
          authenticated = true;
        } else {
          print("User not verified");
          authenticated = false;
        }
      }
    });

    return authenticated;
  }
}
