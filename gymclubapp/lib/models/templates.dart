import 'package:gymclubapp/models/exercises.dart';

class Template {
  String docID;
  String name;
  String description;
  int exerciseCount;
  List<Exercise> exercises = [];

  Template({
    required this.docID,
    required this.name,
    required this.description,
    required this.exerciseCount,
  });

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }
}
