// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Checks if Username is Available
  Future<bool> usernameAvailable(String username) async {
    if (username.length < 5) {
      return false;
    }

    final query = await db.collection("users").get();

    for (dynamic documentSnapshot in query.docs) {
      String docUsername = documentSnapshot['username'];
      if (docUsername.toLowerCase() == username.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  // Create User with Email & Password
  Future<String> createUserWithEmailAndPassword(
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      // Creating user in FirebaseAuth
      final credentials = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      User? user = credentials.user;

      if (user != null) {
        // User Data
        final userData = {
          "firstName": null,
          "lastName": null,
          "username": usernameController.text,
          "email": emailController.text,
          "phoneNumber": null,
          "DoB": null,
          "gymRef": null,
          // Socials
          "instagram": null,
          "tiktok": null,
          "snapchat": null,
        };

        // Adding data to database
        db.collection("users").doc(user.uid).set(userData);
        // Sending Email Verification
        user.sendEmailVerification();
        return '';
      } else {
        return 'User is null!';
      }
    } catch (e) {
      return e.toString();
    }
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
    // Navigator.push(context,
    //     MaterialPageRoute(builder: ((context) => const SignInScreen())));
  }
}
