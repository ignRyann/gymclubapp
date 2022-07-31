class Exercise {
  String name;
  String note;
  List reps = []; // [9,15,15]
  List weights = [];

  Exercise({
    required this.name,
    required this.note,
    required this.reps,
    required this.weights,
  });

  Exercise copy() {
    Exercise copy = Exercise(
        name: name, note: note, reps: reps.toList(), weights: weights.toList());
    return copy;
  }
}
