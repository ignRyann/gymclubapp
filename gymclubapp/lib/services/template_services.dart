// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymclubapp/models/models.dart';

class TemplateService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // [Function] Checks if a Template Group Name is avilable
  Future<bool> groupNameAvailable(String name) async {
    User? user = auth.currentUser;
    if (name.length < 3 || user == null || name.length > 30) {
      return false;
    }

    final query = await db
        .collection("users")
        .doc(user.uid)
        .collection("templateGroups")
        .get();

    for (dynamic documentSnapshot in query.docs) {
      String docGroupName = documentSnapshot['name'];
      if (docGroupName.toLowerCase() == name.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  Future<bool> newGroupNameAvailable(String oldName, String newName) async {
    if (oldName.toLowerCase() == newName.toLowerCase()) {
      return true;
    }

    return groupNameAvailable(newName);
  }

  // [Function] Create Template Group
  Future<bool> createTemplateGroup(String name, String description) async {
    User? user = auth.currentUser;
    if (user != null) {
      Map<String, dynamic> templateGroup = {
        "name": name,
        "description": description,
        "templateNames": [],
      };
      await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .add(templateGroup)
          .then((documentSnapshot) {});

      return true;
    }
    return false;
  }

  // [Function] Update Template Group
  Future<bool> editTemplateGroup(String docID, String newName,
      String newDescription, List<String> newTemplates) async {
    final data = {
      "name": newName,
      "description": newDescription,
      "templateNames": newTemplates
    };
    try {
      await db
          .collection("users")
          .doc(auth.currentUser?.uid)
          .collection("templateGroups")
          .doc(docID)
          .set(data);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // [Function] Remove Template Group
  Future<bool> removeTemplateGroup(TemplateGroup templateGroup) async {
    try {
      await db
          .collection("users")
          .doc(auth.currentUser?.uid)
          .collection("templateGroups")
          .doc(templateGroup.docID)
          .delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
