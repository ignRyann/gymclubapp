class Exercise {
  String docID;
  String name;
  String note;
  List reps; // [9,15,15]
  List weights; // [32,28,28]

  Exercise({
    required this.docID,
    required this.name,
    required this.note,
    required this.reps,
    required this.weights,
  });
}
