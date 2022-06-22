import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authState => auth.authStateChanges();

  User? getUser() {
    return auth.currentUser;
  }

  void signOut(BuildContext context) {
    auth.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const SignInScreen())));
  }
}
