import 'package:gymclubapp/models/models.dart';

class Workout {
  String title = "";
  String note = "";
  List<Exercise> exercises = [];

  fromTemplate(Template template) {
    title = template.name;
    note = template.description;
    exercises = template.exercises;
  }

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }
}
