class Exercise {
  String name;
  String note;
  List reps; // [9,15,15]
  List weights = [];

  Exercise({
    required this.name,
    required this.note,
    required this.reps,
  });

  Exercise copy() {
    return Exercise(name: name, note: note, reps: reps.toList());
  }
}
