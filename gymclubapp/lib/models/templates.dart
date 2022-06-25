import 'package:gymclubapp/models/exercises.dart';

class WorkoutTemplate {
  String templateName;
  String templateDescription;
  List<Exercise> templateExercises;

  WorkoutTemplate({
    required this.templateName,
    required this.templateDescription,
    required this.templateExercises,
  });

  void addExercise(Exercise exercise) {
    templateExercises.add(exercise);
  }

  void removeExercise(String exerciseName) {
    for (Exercise exercise in templateExercises) {
      if (exercise.name == exerciseName) {
        templateExercises.remove(exercise);
        break;
      }
    }
  }
}
