// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  const Template({Key? key}) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    // [Widget] Workout Container
    final workout = Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          onPressed: () {
            print("Redirect to Specific Workout");
            // TODO Redirect to 'Specific Workout' Page
          },
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.grey),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          child: Column(
            children: const [
              SizedBox(height: 10),
              Text(
                'PUSH',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.black,
              ),
              Text(
                'Micro-Cycle - Month 2',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
            ],
          )),
    );

    // [Widget] Template Column
    final template = Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Template Name',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    print("Template Settings Button has been pressed.");
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            workout,
            workout,
            workout,
          ],
        ));

    // Main Body
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [template, template],
        ));
  }
}
