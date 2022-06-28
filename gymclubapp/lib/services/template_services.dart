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

  bool templateNameAvailable(TemplateGroup templateGroup, String name) {
    return !templateGroup.getTemplateNames().contains(name);
  }

  // [Function] Retrieves a user's data
  Future<List> getData() async {
    List<TemplateGroup> data = [];
    User? user = auth.currentUser;
    if (user != null) {
      // Query to access 'templateGroups' Collection
      final templateGroupQuery =
          db.collection("users").doc(user.uid).collection("templateGroups");

      // Retrieves All groups in templateGroups Collection
      final templateGroupSnapshots =
          await templateGroupQuery.orderBy('name').get();

      // Iterate through each document in 'templateGroups' Collection
      for (dynamic templateGroupSnapshot in templateGroupSnapshots.docs) {
        // Creating TemplateGroup Object
        final templateGroup = TemplateGroup(
          docID: templateGroupSnapshot.id,
          name: templateGroupSnapshot['name'],
          description: templateGroupSnapshot['description'],
        );

        // Iterates through all the templateNames
        for (String templateName in templateGroupSnapshot['templateNames']) {
          // Query to access 'templateName' doc in 'templateGroups' collection
          final templateQuery = templateGroupQuery
              .doc(templateGroupSnapshot.id)
              .collection("templates")
              .doc(templateName);

          // Retrieving 'templateName' document snapshot
          final templateSnapshot = await templateQuery.get();

          // Creating Template() Object
          final template = Template(
              name: templateName,
              description: templateSnapshot['description'],
              exerciseCount: templateSnapshot['exerciseCount']);

          for (var i = 0; i < templateSnapshot['exerciseCount']; i++) {
            // Retrieving each Exercise document in 'exercises' collection
            final exerciseSnapshot = await templateQuery
                .collection("exercises")
                .doc(i.toString())
                .get();

            // Creating Exercise() Object
            final exercise = Exercise(
              name: exerciseSnapshot['exercise'],
              note: exerciseSnapshot['note'],
              reps: List.from(exerciseSnapshot['reps']),
              weights: List.from(exerciseSnapshot['weights']),
            );
            // Adding Exercise() object to Template.exercises
            template.addExercise(exercise);
          }
          // Adding Template() object to templateGroup.templates
          templateGroup.addTemplate(template);
        }
        data.add(templateGroup);
      }
    }
    return data;
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
