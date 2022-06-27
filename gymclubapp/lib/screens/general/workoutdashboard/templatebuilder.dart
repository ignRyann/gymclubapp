// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/services/template_services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TemplateBuilder extends StatefulWidget {
  const TemplateBuilder({Key? key}) : super(key: key);

  @override
  State<TemplateBuilder> createState() => _TemplateBuilderState();
}

class _TemplateBuilderState extends State<TemplateBuilder> {
  // User Data (Templates)
  late List _data;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] Main Body
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.62,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: _loaded
          ? ListView.builder(
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return templateGroup(_data, index);
              })
          : const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  // [Function] Retrieve User Data
  void getData() async {
    _data = await TemplateService().getData();
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

  // [Function] Retrieve TemplateGroup layout
  Container templateGroup(List data, int index) {
    TemplateGroup templateGroupData = data[index];
    // [Widget] WorkoutTemplate List<Widget>
    List<Widget> workoutTemplateWidgets = [];
    for (int i = 0; i < templateGroupData.templates.length; i++) {
      workoutTemplateWidgets.add(workoutLayout(templateGroupData, i));
    }

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
                Row(children: [
                  // [Widget] Add Template IconButton
                  IconButton(
                    onPressed: () {
                      print(
                          "${templateGroupData.name} Add Template Button has been pressed.");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTemplateScreen(
                                  templateGroup: templateGroupData)));
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                  ),
                  // [Widget] Edit TemplateGroup IconButton
                  IconButton(
                    onPressed: () {
                      print(
                          "${templateGroupData.name} Edit Button has been pressed.");
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  // [Widget] Delete TemplateGroup IconButton
                  IconButton(
                    onPressed: () {
                      TemplateService()
                          .removeTemplateGroup(templateGroupData)
                          .then((isDeleted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (((context) => const HomeScreen()))));
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ]),
              ],
            ),
            // const Divider(
            //   thickness: 2,
            //   color: Colors.white30,
            // ),
            if (templateGroupData.description.isNotEmpty)
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    templateGroupData.description.length > 50
                        ? "${templateGroupData.description.substring(0, 50)}.."
                        : templateGroupData.description,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: workoutTemplateWidgets,
            )
          ],
        ));
  }

  // [Function] Retrieve Workout Slidable
  Slidable workoutLayout(TemplateGroup templateGroup, int index) {
    final Template workoutTemplate = templateGroup.templates[index];

    return Slidable(
        // Left Side Actions
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (BuildContext context) {
                  print(
                      "${workoutTemplate.name} Delete button has been pressed.");
                }),
            SlidableAction(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                onPressed: (BuildContext context) {
                  print(
                      "${workoutTemplate.name} Edit button has been pressed.");
                })
          ],
        ),
        // Right Side Actions
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green,
              icon: Icons.add_circle,
              onPressed: (BuildContext context) {
                print("${workoutTemplate.name} Start button has been pressed");
              },
            )
          ],
        ),
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.black38,
                    Colors.transparent
                  ]),
              // color: Colors.black38,
              border: Border.symmetric(
                horizontal: BorderSide(width: 1.0, color: Colors.white30),
              ),
            ),
            child: Text(
              workoutTemplate.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )));
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
            // https://pub.dev/packages/popover
            // Pop Over introducing 'Edit' & 'Start' Button
            // https://pub.dev/packages/flutter_slidable
            // Slidable Action List
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              if (workoutTemplate.description.isNotEmpty)
                Text(
                  workoutTemplate.description.length > 50
                      ? "${workoutTemplate.description.substring(0, 50)}.."
                      : workoutTemplate.description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          )),
    );
  }
}
