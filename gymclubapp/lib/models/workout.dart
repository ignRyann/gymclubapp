import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymclubapp/models/models.dart';

class Workout {
  // Connections
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  // Data
  String title = "";
  String note = "";
  List<Exercise> exercises = [];
  List media = [];

  fromTemplate(Template template) {
    title = template.name;
    note = template.description;
    exercises = template.exercises;
  }

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  Future<void> post(String uid) async {
    final postQuery = db.collection("users").doc(uid).collection("posts");

    final postData = {
      "title": title,
      "description": note,
      "media": media,
      "timestamp": Timestamp.now()
    };

    await postQuery.add(postData).then((docReference) {
      for (int i = 0; i < exercises.length; i++) {
        Exercise currentExercise = exercises[i];
        docReference.collection("exercises").doc(i.toString()).set({
          "name": currentExercise.name,
          "note": currentExercise.note,
          "reps": currentExercise.reps,
          "weights": currentExercise.weights,
        });
      }
    });
  }
}
