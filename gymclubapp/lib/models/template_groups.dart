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

  // Checks if Template name is available including its own name
  bool newTemplateNameAvailable(String oldName, String newName) {
    if (oldName.toLowerCase() == newName.toLowerCase()) {
      return true;
    }

    return templateNameAvailable(newName);
  }

  // Add Template
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

  // Edit Template
  Future<void> updateTemplate(String uid, Template template) async {
    final db = FirebaseFirestore.instance;

    final templateRef = db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .collection("templates")
        .doc(template.docID);

    // Deleting unwanted Exercises
    final templateSnapshot = await templateRef.collection("exercises").get();
    int databaseCount = templateSnapshot.docs.length;
    if (databaseCount > template.exercises.length) {
      while (databaseCount != template.exercises.length) {
        databaseCount -= 1;
        templateRef
            .collection("exercises")
            .doc(databaseCount.toString())
            .delete();
      }
    }

    // Setting Template Name, Description
    // Preparing Template Information
    final templateInfo = {
      "name": template.name,
      "description": template.description,
    };

    await templateRef.set(templateInfo);

    // Changing Template Name in its parent group : TemplateGroup
    var index = templateNames.indexOf(template.name);
    templateNames.replaceRange(index, index + 1, [template.name]);

    db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .update({"templateNames": templateNames});

    // Updating Exercises within the Template
    for (int i = 0; i < template.exercises.length; i++) {
      final exerciseRef = templateRef.collection("exercises").doc(i.toString());
      // Preparing Exercise Information
      final exercise = template.exercises[i];
      final exerciseInfo = {
        "name": exercise.name,
        "note": exercise.note,
        "reps": exercise.reps,
        "weights": exercise.weights,
      };
      exerciseRef.set(exerciseInfo);
    }
  }

  // Delete Template
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
