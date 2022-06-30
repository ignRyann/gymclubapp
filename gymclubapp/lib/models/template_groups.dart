import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String docID;
  String name;
  String description;
  List<String> templateNames = [];
  List<Template> templates = [];

  TemplateGroup({
    required this.docID,
    required this.name,
    required this.description,
    required this.templateNames,
  });

  // Add Template
  void addTemplate(Template template) {
    templates.add(template);
  }

  // Checks if Template name is available
  bool templateNameAvailable(String name) {
    return !templateNames.contains(name);
  }

  // Add Template to Template Group
  Future<void> createTemplate(
      String uid, String name, String description) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .collection("templates")
        .add({
      "name": name,
      "description": description,
      "exerciseCount": 0,
    });

    templateNames.add(name);

    db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .update({"templateNames": templateNames});
  }

  // Delete Template from TemplateGroup
  Future<void> deleteTemplate(String uid, Template template) async {
    final db = FirebaseFirestore.instance;
    // Deleting Template
    final templateGroupQuery =
        db.collection("users").doc(uid).collection("templateGroups").doc(docID);
    await templateGroupQuery
        .collection("templates")
        .doc(template.docID)
        .delete();

    // Updating 'templateNames' field in TemplateGroup Doc
    templateNames.remove(template.name);

    db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .update({"templateNames": templateNames});
  }
}
