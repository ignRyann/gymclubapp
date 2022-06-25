// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/template.dart';
import '../../../utils/utils.dart';

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
      backgroundColor: Colors.black,
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
          print("Redirect to 'Start Workout' Page");
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
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    // [Widget] Template Editor Row
    final templateEditor = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            print("Add Template");
          },
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        IconButton(
            onPressed: () {
              print("ReOrder Templates");
            },
            icon: const Icon(
              Icons.layers_rounded,
              color: Colors.white,
              size: 40.0,
            )),
      ],
    );

    // Main Body
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: workoutDashboardAppBar,
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 40),
                child: Column(
                  children: <Widget>[
                    startFreshWorkout,
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.white,
                      thickness: 2.0,
                    ),
                    templateEditor,
                    const Template(),
                  ],
                ))),
      ),
    );
  }
}
