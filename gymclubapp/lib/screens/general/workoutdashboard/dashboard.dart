import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/screens.dart';
import '../../../utils/utils.dart';

class WorkoutDashboardScreen extends StatefulWidget {
  final String userUID;
  const WorkoutDashboardScreen({Key? key, required this.userUID})
      : super(key: key);

  @override
  State<WorkoutDashboardScreen> createState() => _WorkoutDashboardScreenState();
}

class _WorkoutDashboardScreenState extends State<WorkoutDashboardScreen> {
  // User Data (Templates)
  late DashboardData dashboardData;
  bool _loaded = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  // [Function] Load User Data
  void loadData() async {
    dashboardData = DashboardData(uid: widget.userUID);
    await dashboardData.loadWorkoutData();
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

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
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartWorkoutScreen(
                dashboardData: dashboardData,
                workout: Workout(),
              ),
            ),
          );
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

    // [Widget] Template Groups Editor Row
    final templateGroupsEditor = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Add TemplateGroup IconButton
        IconButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTemplateGroupScreen(userData: dashboardData)))
                .then((value) {
              if (value != null) {
                setState(() {
                  _loaded = false;
                });
                loadData();
              }
            });
          },
          icon: const Icon(
            Icons.add_to_photos_rounded,
            color: Colors.green,
            size: 40.0,
          ),
        ),
        // ReOrder Icon Button
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

    // Main Body
    return Scaffold(
      appBar: workoutDashboardAppBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: _loaded
            ? Column(
                children: <Widget>[
                  startFreshWorkout,
                  const Divider(
                    color: Colors.white,
                    thickness: 2.0,
                  ),
                  const SizedBox(height: 5),
                  templateGroupsEditor,
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dashboardData.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return templateGroupLayout(dashboardData.data[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // [Function] Retrieves Template Group Layout
  Container templateGroupLayout(TemplateGroup templateGroup) {
    List<Widget> templateWidgets = [];
    for (int i = 0; i < templateGroup.templates.length; i++) {
      templateWidgets.add(templateLayout(templateGroup, i));
    }

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black26,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Group Name & Editor
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
                            templateGroup: templateGroup),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _loaded = false;
                        });
                        loadData();
                      }
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
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _loaded = false;
                        });
                        loadData();
                      }
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
                        .then((value) {
                      setState(() {
                        dashboardData.data.remove(templateGroup);
                      });
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
          // Template Group Description
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
          const SizedBox(height: 10),
          SlidableAutoCloseBehavior(
              child: Column(
            children: templateWidgets,
          ))
        ],
      ),
    );
  }

  // [Function] Retrieves Template Slidable Layout
  Slidable templateLayout(TemplateGroup templateGroup, int index) {
    Template template = templateGroup.templates[index];
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
                  setState(() {
                    templateGroup.templateNames.remove(template.name);
                    templateGroup.templates.remove(template);
                  });
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
                          template: template.copy(),
                        ))),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _loaded = false;
                    });
                    loadData();
                  }
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
              Workout workout = Workout();
              workout.fromTemplate(template.copy());
              //TODO Create 'Start Workout' Page given template
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (((context) => StartWorkoutScreen(
                        dashboardData: dashboardData,
                        workout: workout,
                      ))),
                ),
              );
            },
          )
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black54,
                Colors.transparent,
              ]),
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
        ),
      ),
    );
  }
}
