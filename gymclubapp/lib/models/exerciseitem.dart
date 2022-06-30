class ExerciseItem {
  String docID;
  String category;
  String name;

  ExerciseItem({
    required this.docID,
    required this.category,
    required this.name,
  });

  String getDocRef() {
    return "exercises/$docID";
  }
}
