// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TemplateService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<bool> groupNameAvailable(String name) async {
    User? user = auth.currentUser;
    if (name.length < 3 || user == null) {
      return false;
    }

    final query = await db
        .collection("users")
        .doc(user.uid)
        .collection("templates")
        .get();

    for (dynamic documentSnapshot in query.docs) {
      String docGroupName = documentSnapshot['name'];
      if (docGroupName.toLowerCase() == name.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  Future<void> getTemplateNames(String groupName) async {
    User? user = auth.currentUser;
    if (user != null) {
      List templateNames = [];
      // Retrieves TemplateGroup Collection
      final templateGroupSnapshot = await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .where('name', isEqualTo: groupName)
          .get();

      // Retrieves Template Collection
      final templateSnapshots = await templateGroupSnapshot.docs[0].reference
          .collection("templates")
          .get();

      // Retrieves & Stores Template Names
      for (dynamic templateSnapshot in templateSnapshots.docs) {
        templateNames.add(templateSnapshot['name']);
      }

      // Sorts items alphabetically
      templateNames.sort((a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      });
    }
  }
}
