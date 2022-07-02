// ignore_for_file: avoid_print, unused_import

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/addtemplategroup.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/templatebuilder.dart';
import '../../../utils/utils.dart';

class WorkoutDashboardScreen extends StatefulWidget {
  final String userUID;
  const WorkoutDashboardScreen({Key? key, required this.userUID})
      : super(key: key);

  @override
  State<WorkoutDashboardScreen> createState() => _WorkoutDashboardScreenState();
}

class _WorkoutDashboardScreenState extends State<WorkoutDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // [Widget] WorkoutDashboard AppBar
    final workoutDashboardAppBar = AppBar(
      automaticallyImplyLeading: false,
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
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          print("Redirect to 'Start Workout' Page");
          // TODO Redirect to 'Start Workout' Page
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
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

    // Main Body
    return Scaffold(
        appBar: workoutDashboardAppBar,
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: () async => !Navigator.of(context).userGestureInProgress,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(gradient: gradientDesign()),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                    child: Column(
                      children: <Widget>[
                        startFreshWorkout,
                        const SizedBox(height: 20),
                        const Divider(
                          color: Colors.white,
                          thickness: 2.0,
                        ),
                        const SizedBox(height: 10),
                        TemplateBuilder(userUID: widget.userUID),
                      ],
                    ))),
          ),
        ));
  }
}
