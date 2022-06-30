// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/addtemplategroup.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/edittemplategroup.dart';
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
  late UserData userData;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] Template Editor Row
    final templateEditor = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddTemplateGroupScreen(userData: userData)));
          },
          icon: const Icon(
            Icons.add_to_photos_rounded,
            color: Colors.green,
            size: 40.0,
          ),
        ),
        IconButton(
            onPressed: () {
              print("ReOrder Templates");
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
                itemCount: userData.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    templateGroup(userData.data, index),
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
    userData = UserData(uid: widget.userUID);
    await userData.loadUserData();
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
                                  userData: userData,
                                  templateGroup: templateGroup)));
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
                                    userUID: widget.userUID,
                                    templateGroup: templateGroup,
                                    items: templateGroup.getTemplateNames(),
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
                      userData
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
