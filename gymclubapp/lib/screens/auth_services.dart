import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authState => auth.authStateChanges();

  // Retrieve User if set, otherwise null
  // Might have to be async + Future<User?>
  Future<User?> getUser() async {
    return auth.currentUser;
  }

  // Sign User in with Email & Password
  Future<String> signInWithEmailAndPassword(
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      User? user = credentials.user;
      if (user != null) {
        if (user.emailVerified) {
          return '';
        } else {
          return 'The account linked to ${user.email} has not been verified. An email verification has beent sent!';
        }
      } else {
        return 'User is null!';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Sign User Out
  void signOut(BuildContext context) {
    auth.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const SignInScreen())));
  }
}
