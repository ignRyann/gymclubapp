// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymclubapp/models/models.dart';

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

  Future<void> getData() async {
    List<TemplateGroup> data = [];
    User? user = auth.currentUser;
    if (user != null) {
      // Retrieves All groups in templateGroups Collection
      final templateGroupSnapshots = await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
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
            print(
                "${templateGroup.name} / ${template.name} / ${exercise.name}");
          }
          // Adding Template() object to templateGroup.templates
          templateGroup.addTemplate(template);
        }
      }
    } else {
      print("User is null");
    }
  }

  Future<void> getTemplateNames(String groupName) async {
    User? user = auth.currentUser;
    if (user != null) {
      // Retrieves TemplateGroup Collection
      final templateGroupSnapshot = await db
          .collection("users")
          .doc(user.uid)
          .collection("templateGroups")
          .where('name', isEqualTo: groupName)
          .get();

      // // Retrieves Template Collection
      // final templateSnapshots = await templateGroupSnapshot.docs[0].reference
      //     .collection("templates")
      //     .get();

      // // Retrieves & Stores Template Names
      // for (dynamic templateSnapshot in templateSnapshots.docs) {
      //   print(templateSnapshot['name']);
      // }
      for (dynamic querySnapshot in templateGroupSnapshot.docs) {
        final templateNames = querySnapshot['templateNames'];
        for (String templateName in templateNames) {
          print(templateName);

          final templateSnapshot = await templateGroupSnapshot.docs[0].reference
              .collection("templates")
              .doc(templateName)
              .get();
          print("-> ${templateSnapshot['exerciseCount']}");
        }
      }
    }
  }
}
