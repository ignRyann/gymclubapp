// ignore_for_file: unused_import

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
    if (FirebaseAuth.instance.currentUser != null) {
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
}
