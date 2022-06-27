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

  // [Function] Retrieves a user's data
  Future<List> getData() async {
    List<TemplateGroup> data = [];
    User? user = auth.currentUser;
    if (user != null) {
      // Retrieves All groups in templateGroups Collection
      final templateGroupSnapshots = await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .orderBy('name')
          .get();

      // Iterate through each document in 'templateGroups' Collection
      for (dynamic templateGroupSnapshot in templateGroupSnapshots.docs) {
        // Creating TemplateGroup Object
        final templateGroup = TemplateGroup(
          name: templateGroupSnapshot['name'],
          description: templateGroupSnapshot['description'],
        );

        // Retrieves Template Group Document Snapshot
        final docSnapshot = await db
            .collection("users")
            .doc(user.uid)
            .collection("templateGroups")
            .where("name", isEqualTo: templateGroupSnapshot['name'])
            .get();

        // Iterates through all the templateNames
        for (String templateName in templateGroupSnapshot['templateNames']) {
          // Retrieving 'templateName' document snapshot
          final templateSnapshot = await docSnapshot.docs[0].reference
              .collection("templates")
              .doc(templateName)
              .get();

          // Creating Template() Object
          final template = Template(
              name: templateName,
              description: templateSnapshot['note'],
              exerciseCount: templateSnapshot['exerciseCount']);

          for (var i = 0; i < templateSnapshot['exerciseCount']; i++) {
            // Retrieving each Exercise document in 'exercises' collection
            final exerciseSnapshot = await docSnapshot.docs[0].reference
                .collection("templates")
                .doc(templateName)
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
  bool createTemplateGroup(String name, String description) {
    return false;
  }
}
