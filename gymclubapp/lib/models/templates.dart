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

  Template copy() {
    Template copy = Template(
      docID: docID,
      name: name,
      description: description,
    );
    for (Exercise exercise in exercises) {
      copy.addExercise(exercise.copy());
    }
    return copy;
  }
}
