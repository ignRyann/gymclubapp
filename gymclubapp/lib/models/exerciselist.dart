import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymclubapp/models/models.dart';

class ExerciseList {
  final db = FirebaseFirestore.instance;

  List<ExerciseItem> exercises = [];

  Future<void> loadData() async {
    final exerciseSnapshots = await db.collection("exercises").get();

    for (DocumentSnapshot exerciseSnapshot in exerciseSnapshots.docs) {
      exercises.add(ExerciseItem(
          docID: exerciseSnapshot.id,
          category: exerciseSnapshot['category'],
          name: exerciseSnapshot['name']));
    }
  }
}
