// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TemplateBuilder extends StatefulWidget {
  final String userUID;
  const TemplateBuilder({Key? key, required this.userUID}) : super(key: key);

  @override
  State<TemplateBuilder> createState() => _TemplateBuilderState();
}

class _TemplateBuilderState extends State<TemplateBuilder> {
  // User Data (Templates)
  late DashboardData dashboardData;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] Template Groups Editor Row
    final templateEditor = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTemplateGroupScreen(userData: dashboardData)))
                .then((value) {
              setState(() {
                _loaded = false;
              });
              loadData();
            });
          },
          icon: const Icon(
            Icons.add_to_photos_rounded,
            color: Colors.green,
            size: 40.0,
          ),
        ),
        IconButton(
            onPressed: () {
              log("reOrder Template Groups Button has been pressed.");
            },
            icon: const Icon(
              Icons.layers_clear,
              color: Colors.yellow,
              size: 40.0,
            )),
      ],
    );

    // [Widget] Main Body
    return Column(children: [
      templateEditor,
      const SizedBox(
        height: 20,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        padding: EdgeInsets.fromLTRB(
            0, 0, 0, MediaQuery.of(context).size.height * 0.1),
        child: _loaded
            ? ListView.builder(
                itemCount: dashboardData.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    templateGroup(dashboardData.data, index),
                    const SizedBox(height: 20),
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
      ),
    ]);
  }

  // [Function] Load User Data
  void loadData() async {
    log("loading data.");
    dashboardData = DashboardData(uid: widget.userUID);
    await dashboardData.loadUserData();
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

  // [Function] Retrieve TemplateGroup layout
  Container templateGroup(List data, int index) {
    TemplateGroup templateGroup = data[index];
    // [Widget] WorkoutTemplate List<Widget>
    List<Widget> templateWidgets = [];
    for (int i = 0; i < templateGroup.templates.length; i++) {
      templateWidgets.add(workoutLayout(templateGroup, i));
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
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
                  templateGroup.name,
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
                                  userData: dashboardData,
                                  templateGroup: templateGroup))).then((value) {
                        setState(() {
                          _loaded = false;
                        });
                        loadData();
                      });
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
                                    userData: dashboardData,
                                    templateGroup: templateGroup,
                                    items: templateGroup.templateNames,
                                  ))).then((value) {
                        setState(() {
                          _loaded = false;
                        });
                        loadData();
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  // [Widget] Delete TemplateGroup IconButton
                  IconButton(
                    onPressed: () {
                      dashboardData
                          .deleteTemplateGroup(templateGroup)
                          .then((isDeleted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (((context) => HomeScreen(
                                      userUID: widget.userUID,
                                    )))));
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
            if (templateGroup.description.isNotEmpty)
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    templateGroup.description.length > 50
                        ? "${templateGroup.description.substring(0, 50)}.."
                        : templateGroup.description,
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
    final Template template = templateGroup.templates[index];

    return Slidable(
        groupTag: templateGroup.docID,
        // Left Side Actions
        startActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const DrawerMotion(),
          children: [
            // Delete Button
            SlidableAction(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (BuildContext context) async {
                  await templateGroup
                      .deleteTemplate(widget.userUID, template)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(userUID: widget.userUID)));
                  });
                }),
            // Edit Button
            SlidableAction(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (((context) => EditTemplateScreen(
                                dashboardData: dashboardData,
                                templateGroup: templateGroup,
                                template: template,
                              ))))).then((value) {
                    setState(() {
                      _loaded = false;
                    });
                    loadData();
                  });
                })
          ],
        ),
        // Right Side Actions
        endActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const DrawerMotion(),
          children: [
            // Start Button
            SlidableAction(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green,
              icon: Icons.play_circle,
              onPressed: (BuildContext context) {
                print("${template.name} Start button has been pressed");
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
                horizontal: BorderSide(width: 1, color: Colors.white30),
              ),
            ),
            child: Text(
              template.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )));
  }
}
