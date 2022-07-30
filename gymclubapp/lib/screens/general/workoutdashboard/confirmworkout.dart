import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/utils/widgets.dart';

class ConfirmWorkoutScreen extends StatefulWidget {
  final Workout workout;
  const ConfirmWorkoutScreen({Key? key, required this.workout})
      : super(key: key);

  @override
  State<ConfirmWorkoutScreen> createState() => _ConfirmWorkoutScreenState();
}

class _ConfirmWorkoutScreenState extends State<ConfirmWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    // [Widget] StartWorkoutScreen AppBar
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'LOG',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

    // Main Body
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(),
      ),
    );
  }
}
