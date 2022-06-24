// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../utils/widgets.dart';

class WorkoutDashboardScreen extends StatefulWidget {
  const WorkoutDashboardScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutDashboardScreen> createState() => _WorkoutDashboardScreenState();
}

class _WorkoutDashboardScreenState extends State<WorkoutDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // [Widget] WorkoutDashboard AppBar
    final workoutDashboardAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text(
        'DASHBOARD',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

    // [Widget] Start Workout Elevated Button
    final startFreshWorkout = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          // TODO Redirect to 'Start Workout' Page
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.green;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'Start a Fresh Workout',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: workoutDashboardAppBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    startFreshWorkout,
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white,
                      thickness: 2.0,
                    )
                  ],
                ))),
      ),
    );
  }
}
