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

  void addTemplate(Template template) {
    templates.add(template);
  }

  // [Function] Checks if Template name is available
  bool templateNameAvailable(String name) {
    return !getTemplateNames().contains(name);
  }

  // [Function] Add Template to Template Group
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

    List templateNames = getTemplateNames();
    templateNames.add(name);

    db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .update({"templateNames": templateNames});
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
