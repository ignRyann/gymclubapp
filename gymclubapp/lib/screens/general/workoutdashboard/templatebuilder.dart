// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/edittemplategroup.dart';
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
                return Column(children: [
                  templateGroup(_data, index),
                  const SizedBox(
                    height: 20,
                  )
                ]);
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
    List<Widget> templateWidgets = [];
    for (int i = 0; i < templateGroupData.templates.length; i++) {
      templateWidgets.add(workoutLayout(templateGroupData, i));
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black26,
        ),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTemplateGroupScreen(
                                    templateGroup: templateGroupData,
                                    items: templateGroupData.getTemplateNames(),
                                  )));
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
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )),
            const SizedBox(
              height: 10,
            ),
            SlidableAutoCloseBehavior(
                child: Column(
              children: templateWidgets,
            ))
          ],
        ));
  }

  // [Function] Retrieve Workout Slidable
  Slidable workoutLayout(TemplateGroup templateGroup, int index) {
    final Template workoutTemplate = templateGroup.templates[index];

    return Slidable(
        groupTag: templateGroup.docID,
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
              icon: Icons.forward,
              label: "START",
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
                    Colors.black54,
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
}
