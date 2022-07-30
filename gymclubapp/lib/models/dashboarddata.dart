import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymclubapp/models/models.dart';

class DashboardData {
  // Connections
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  // User Details
  final String uid;
  // User Template Groups, Templates, Exercises, etc
  List<TemplateGroup> data = [];
  // Exercise List
  List<ExerciseItem> exerciseList = [];

  DashboardData({required this.uid});

  // Load Workout Data
  Future<void> loadWorkoutData() async {
    await loadUserTemplates();
    await loadExercises();
  }

  // Load User Data from FireStore
  Future<void> loadUserTemplates() async {
    // TemplateGroups Collection Query
    final templateGroupQuery =
        db.collection("users").doc(uid).collection("templateGroups");

    // Retrieves all groups in templateGroups Collection
    final templateGroupSnapshots =
        await templateGroupQuery.orderBy('name').get();

    // Iterate through each document in 'templateGroups' Collection
    for (QueryDocumentSnapshot templateGroupSnapshot
        in templateGroupSnapshots.docs) {
      // Creating TemplateGroup Object
      final templateGroup = TemplateGroup(
        docID: templateGroupSnapshot.id,
        name: templateGroupSnapshot['name'],
        description: templateGroupSnapshot['description'],
        templateNames: List.from(templateGroupSnapshot['templateNames']),
      );

      // Retrieving all Templates in TemplateGroup
      final templateSnapshotsQuery =
          templateGroupQuery.doc(templateGroup.docID).collection("templates");
      final templateSnapshots = await templateSnapshotsQuery.get();

      // Iterates through each Template in TemplateGroup
      for (String templateName in templateGroup.templateNames) {
        for (QueryDocumentSnapshot templateSnapshot in templateSnapshots.docs) {
          if (templateSnapshot['name'] == templateName) {
            // Creating Template Object
            final template = Template(
                docID: templateSnapshot.id,
                name: templateName,
                description: templateSnapshot['description']);

            final exerciseSnapshotsQuery = templateSnapshotsQuery
                .doc(template.docID)
                .collection("exercises");
            final exerciseSnapshots = await exerciseSnapshotsQuery.get();

            for (QueryDocumentSnapshot exerciseSnapshot
                in exerciseSnapshots.docs) {
              // Creating Exercise Object
              final exercise = Exercise(
                  name: exerciseSnapshot['name'],
                  note: exerciseSnapshot['note'],
                  reps: List.from(exerciseSnapshot['reps']));

              // Add Exercise Object to template.exercises
              template.addExercise(exercise);
            }

            // Adding Template object to templateGroup.templates
            templateGroup.addTemplate(template);
            break;
          }
        }
      }
      data.add(templateGroup);
    }
  }

  // Load Exercises
  Future<void> loadExercises() async {
    final exerciseSnapshots =
        await db.collection("exercises").orderBy("name").get();

    for (DocumentSnapshot exerciseSnapshot in exerciseSnapshots.docs) {
      exerciseList.add(ExerciseItem(
          docID: exerciseSnapshot.id,
          category: exerciseSnapshot['category'],
          name: exerciseSnapshot['name']));
    }
  }

  // Retrieve List of Exercises Dependent on Category
  List<ExerciseItem> getExercises(String category) {
    var categoricList = exerciseList
        .where((exercise) => exercise.category == category)
        .toList();

    return categoricList.isEmpty ? [] : categoricList;
  }

  // Check if Template Group Name is available
  bool groupNameAvailable(String name) {
    if (name.length < 3 || name.length > 30) {
      return false;
    }

    for (TemplateGroup templateGroup in data) {
      if (templateGroup.name.toLowerCase() == name.toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  bool newGroupNameAvailable(String oldName, String newName) {
    if (oldName.toLowerCase() == newName.toLowerCase()) {
      return true;
    }

    return groupNameAvailable(newName);
  }

  // Create new Template Group
  Future<void> createTemplateGroup(String name, String description) async {
    Map<String, dynamic> templateGroup = {
      "name": name,
      "description": description,
      "templateNames": [],
    };
    await db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .add(templateGroup);
  }

  // Update Template Group
  Future<void> editTemplateGroup(String docID, String newName,
      String newDescription, List<String> newTemplates) async {
    final templateGroup = {
      "name": newName,
      "description": newDescription,
      "templateNames": newTemplates,
    };
    await db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(docID)
        .set(templateGroup);
  }

  // Delete Template Group
  Future<void> deleteTemplateGroup(TemplateGroup templateGroup) async {
    await db
        .collection("users")
        .doc(uid)
        .collection("templateGroups")
        .doc(templateGroup.docID)
        .delete();
  }

  // End of Class
}
