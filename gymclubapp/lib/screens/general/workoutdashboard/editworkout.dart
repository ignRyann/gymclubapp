import 'package:flutter/material.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Edit"),
    );
  }
}
