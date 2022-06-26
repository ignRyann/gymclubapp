// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';

class TemplateBuilder extends StatefulWidget {
  const TemplateBuilder({Key? key}) : super(key: key);

  @override
  State<TemplateBuilder> createState() => _TemplateBuilderState();
}

class _TemplateBuilderState extends State<TemplateBuilder> {
  // Dummy Data
  final dummyData = [];

  @override
  Widget build(BuildContext context) {
    // [Widget] Main Body
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.62,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      // child: ListView.builder(
      //     itemCount: dummyData.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return templateGroup(dummyData, index);
      //     }),
    );
  }

  // [Function] Retrieve TemplateGroup layout
  Container templateGroup(List<TemplateGroup> data, int index) {
    final templateGroupData = data[index];
    // [Widget] WorkoutTemplate List<Widget>
    List<Widget> workoutTemplateWidgets = [];
    for (int i = 0; i < templateGroupData.templates.length; i++) {
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
                  templateGroupData.name,
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
    final workoutTemplate = templateGroup.templates[index];
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          onPressed: () {
            print(
                "Redirect to (${templateGroup.name}) Group (${templateGroup.templates[index].name}) Template");
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
                workoutTemplate.name,
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
                workoutTemplate.description,
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
