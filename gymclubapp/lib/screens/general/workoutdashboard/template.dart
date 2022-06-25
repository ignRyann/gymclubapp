// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';

class Template extends StatefulWidget {
  const Template({Key? key}) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  // Dummy Data
  final dummyData = [
    TemplateGroup(
        templateGroupName: "Push/Pull/Legs",
        templateGroupDescription: "To be performed at GymBox",
        templateGroupItems: [
          WorkoutTemplate(
            templateName: "Push",
            templateDescription: "Concentrate on Eccentric",
            templateExercises: [
              Exercise(
                  name: "Dumbell Press",
                  category: "Freeweights",
                  note: "Control Range of Motion",
                  sets: [9, 15, 15],
                  weights: [32, 28, 28]),
            ],
          ),
          WorkoutTemplate(
            templateName: "Pull",
            templateDescription: "Focus on pulling with elbows",
            templateExercises: [
              Exercise(
                  name: "Deadlift",
                  category: "Freeweights",
                  note: "Control Range of Motion",
                  sets: [5, 5, 5],
                  weights: [100, 100, 100]),
            ],
          ),
          WorkoutTemplate(
            templateName: "Legs",
            templateDescription: "Slow Eccentric, Quick Concentric",
            templateExercises: [
              Exercise(
                  name: "Squat",
                  category: "Freeweights",
                  note: "Control Range of Motion",
                  sets: [9, 15],
                  weights: [100, 150]),
            ],
          ),
        ]),
    TemplateGroup(
        templateGroupName: "Upper/Lower",
        templateGroupDescription: "To be performed at PureGym TCR",
        templateGroupItems: [
          WorkoutTemplate(
            templateName: "Upper",
            templateDescription: "Full ROM + Good Tempo",
            templateExercises: [
              Exercise(
                  name: "Dumbell Press",
                  category: "Freeweights",
                  note: "Control Range of Motion",
                  sets: [9, 15, 15],
                  weights: [32, 28, 28]),
            ],
          ),
          WorkoutTemplate(
            templateName: "Lower",
            templateDescription: "Ensure Good Form",
            templateExercises: [
              Exercise(
                  name: "Squat",
                  category: "Freeweights",
                  note: "Control Range of Motion",
                  sets: [9, 15],
                  weights: [100, 150]),
            ],
          ),
        ]),
  ];

  @override
  Widget build(BuildContext context) {
    // [Widget] Main Body
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.62,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListView.builder(
          itemCount: dummyData.length,
          itemBuilder: (BuildContext context, int index) {
            return templateGroup(dummyData, index);
          }),
    );
  }

  // [Function] Retrieve TemplateGroup layout
  Container templateGroup(List<TemplateGroup> data, int index) {
    final templateGroupData = data[index];
    // [Widget] WorkoutTemplate List<Widget>
    List<Widget> workoutTemplateWidgets = [];
    for (int i = 0; i < templateGroupData.templateGroupItems.length; i++) {
      workoutTemplateWidgets.add(workout(templateGroupData, i));
    }

    // Main Body
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  templateGroupData.templateGroupName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    print(
                        "$templateGroupData Settings Button has been pressed.");
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.yellow,
                  ),
                )
              ],
            ),
            Column(
              children: workoutTemplateWidgets,
            )
          ],
        ));
  }

  // [Function] Retrieve Workout Layout
  Container workout(TemplateGroup templateGroup, int index) {
    final workoutTemplate = templateGroup.templateGroupItems[index];
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          onPressed: () {
            print(
                "Redirect to (${templateGroup.templateGroupName}) Group (${templateGroup.templateGroupItems[index].templateName}) Template");
            // TODO Redirect to 'Specific Workout' Page
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.grey),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                workoutTemplate.templateName,
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              Text(
                workoutTemplate.templateDescription,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
            ],
          )),
    );
  }
}
