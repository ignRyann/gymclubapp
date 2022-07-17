import 'package:gymclubapp/models/exercises.dart';

class Template {
  String docID;
  String name;
  String description;
  List<Exercise> exercises = [];

  Template({
    required this.docID,
    required this.name,
    required this.description,
  });

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }
}
