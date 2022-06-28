// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String docID;
  String name;
  String description;
  List<Template> templates = [];

  TemplateGroup({
    required this.docID,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
      "description": description,
      "templateNames": getTemplateNames(),
    };
  }

  void addTemplate(Template template) {
    templates.add(template);
  }

  // [Function] Add Template to Template Group
  Future<bool> createTemplate(
      String templateName, String templateDescription) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("When creating $templateName template, User was null");
      return false;
    }
    try {
      final db = FirebaseFirestore.instance;
      await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .doc(docID)
          .collection("templates")
          .doc(templateName)
          .set({"description": templateDescription, "exerciseCount": 0});

      List templateNames = getTemplateNames();
      templateNames.add(templateName);

      db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .doc(docID)
          .update({"templateNames": templateNames});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // [Function] Returns a list of Template Names
  List<String> getTemplateNames() {
    List<String> templateNames = [];
    for (Template template in templates) {
      templateNames.add(template.name);
    }
    return templateNames;
  }
}
