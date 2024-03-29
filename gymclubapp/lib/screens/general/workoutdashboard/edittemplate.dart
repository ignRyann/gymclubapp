import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/general/workoutdashboard/addexercise.dart';
import 'package:gymclubapp/utils/utils.dart';

class EditTemplateScreen extends StatefulWidget {
  final DashboardData dashboardData;
  final TemplateGroup templateGroup;
  final Template template;
  const EditTemplateScreen({
    Key? key,
    required this.dashboardData,
    required this.templateGroup,
    required this.template,
  }) : super(key: key);

  @override
  State<EditTemplateScreen> createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends State<EditTemplateScreen> {
  // Global Key
  final _templateKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // Error Messages
  bool _templateNameAvailable = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template.name);
    _descriptionController =
        TextEditingController(text: widget.template.description);
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] AppBar
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'Edit Template',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

    // [Widget] Template Name TextFormField
    final name = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty || value.length < 3 || value.length > 30) {
            return 'Template Name must be between 3 & 30 characters.';
          } else if (!_templateNameAvailable) {
            return 'Template Name is already used!';
          }
        }
        return null;
      }),
      controller: _nameController,
      enableSuggestions: false,
      autocorrect: true,
      autofocus: false,
      cursorColor: Colors.white,
      onChanged: (text) {
        setState(() {
          _templateNameAvailable = widget.templateGroup
              .newTemplateNameAvailable(widget.template.name, text);
        });
      },
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.dashboard,
            color: Colors.white70,
          ),
          suffixIcon: _templateNameAvailable
              ? const Icon(
                  Icons.check_outlined,
                  color: Colors.green,
                  size: 30.0,
                )
              : const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 30.0,
                ),
          labelText: 'Enter New Template Name',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Template Group Description TextFormField
    final description = TextFormField(
      controller: _descriptionController,
      enableSuggestions: false,
      autocorrect: true,
      autofocus: false,
      maxLines: 2,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.description,
            color: Colors.white70,
          ),
          labelText: 'Enter New Template Description',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Add Exercise Row
    final addExerciseRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Exercise List Header
        Text(
          "Exercise List",
          style: TextStyle(
            color: Colors.yellowAccent.withOpacity(0.85),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Add Exercise Icon
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddExerciseScreen(
                          dashboardData: widget.dashboardData,
                        )),
              ).then(
                (exerciseName) {
                  if (exerciseName != null) {
                    log(exerciseName);
                    setState(() {
                      widget.template.addExercise(Exercise(
                          name: exerciseName, note: "", reps: [], weights: []));
                    });
                  }
                },
              );
            },
            icon: const Icon(
              Icons.add_circle_outlined,
              size: 30,
              color: Colors.green,
            ))
      ],
    );

    // [Widget] Customise Template Exercises Expanded
    final customiseTemplate = Expanded(
      child: Theme(
        data: ThemeData(
            canvasColor: Colors.transparent, shadowColor: Colors.transparent),
        child: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return exerciseLayout(index);
            },
            itemCount: widget.template.exercises.length,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Exercise item =
                    widget.template.exercises.removeAt(oldIndex);
                widget.template.exercises.insert(newIndex, item);
              });
            }),
      ),
    );

    // [Widget] Save Template Button
    final saveTemplateButton = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          if (_templateKey.currentState!.validate() && _templateNameAvailable) {
            await widget.templateGroup
                .updateTemplate(widget.dashboardData.uid, widget.template)
                .then((value) {
              Navigator.pop(context, "");
            });
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'SAVE',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    // Main Body
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: appBar,
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: Form(
            key: _templateKey,
            child: Column(
              children: <Widget>[
                name,
                const SizedBox(height: 15),
                description,
                const SizedBox(height: 10),
                addExerciseRow,
                const Divider(color: Colors.white),
                customiseTemplate,
                saveTemplateButton
              ],
            )),
      ),
    );
  }

  // [Function] Retrieve Exercise Layout
  Column exerciseLayout(int index) {
    // Variables
    Exercise exercise = widget.template.exercises[index];
    final TextEditingController exerciseNoteController =
        TextEditingController(text: exercise.note);
    return Column(
      key: Key(index.toString()),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black45,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Exercise Name
                  Text(
                    exercise.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  // Icon Buttons
                  Row(children: [
                    // Add Set Icon
                    IconButton(
                        onPressed: () {
                          setState(() {
                            exercise.reps.add(0);
                            exercise.weights.add(0);
                          });
                        },
                        icon: const Icon(
                          Icons.add_to_photos_rounded,
                          color: Colors.green,
                        )),
                    // Delete Icon
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.template.exercises.remove(exercise);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ])
                ],
              ),
              // Description TextFormField
              TextFormField(
                controller: exerciseNoteController,
                enableSuggestions: false,
                autofocus: false,
                maxLines: null,
                cursorColor: Colors.white,
                onChanged: (value) {
                  exercise.note = value;
                },
                style: const TextStyle(color: Colors.amber),
                decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(0.1),
                  prefixIcon: const Icon(
                    Icons.edit_note_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        // style: BorderStyle.none,
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Exercise Sets/Reps/Weight
              getSetsRepsLayout(exercise),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  // [Function] Retrieves the set / reps template
  Row getSetsRepsLayout(Exercise exercise) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Set Index
        Column(children: getSetIndexList(exercise.reps.length)),
        // Reps Count
        Column(
          children: getRepsList(exercise),
        ),
        // Delete Buttons
        Column(
          children: getDeleteButtons(exercise, exercise.reps.length),
        ),
      ],
    );
  }

  // [Function] Get Set Index List
  List<Widget> getSetIndexList(int count) {
    List<Widget> setIndexList = [
      const Text(
        "SET",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ];
    for (int i = 0; i < count; i++) {
      final setIndexItem = Container(
        width: 40,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.4)),
        child: Text(
          (i + 1).toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      );
      setIndexList.add(setIndexItem);
      setIndexList.add(const SizedBox(height: 10));
    }
    return setIndexList;
  }

  // [Function] Get Reps List
  List<Widget> getRepsList(Exercise exercise) {
    // Creating List
    List<Widget> repsList = [
      const Text(
        "REPS",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
    ];
    // Iterating through each Rep
    for (int i = 0; i < exercise.reps.length; i++) {
      // Creating TextEditingController
      TextEditingController controller =
          TextEditingController(text: exercise.reps[i].toString());
      controller.selection = TextSelection.fromPosition(TextPosition(
        offset: controller.text.length,
      ));

      // Creating Reps Container
      final repsItem = Container(
        width: 80,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.4),
        ),
        // Reps TextField
        child: TextField(
          cursorColor: Colors.white,
          decoration: const InputDecoration(focusedBorder: InputBorder.none),
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: const TextStyle(
            height: 0.8,
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (value) {
            if (value.length > 3) {
              setState(() {
                controller.text = controller.text.substring(0, 3);
              });
            } else {
              exercise.reps[i] = value;
            }
          },
        ),
      );
      // Adding items to List
      repsList.add(repsItem);
      repsList.add(const SizedBox(height: 10));
    }
    return repsList;
  }

  // [Function] Get Delete Button List
  List<Widget> getDeleteButtons(Exercise exercise, int count) {
    final List<Widget> deleteButtons = [
      const Text(
        "DELETE",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ];
    // Iterating Delete Button Creation
    for (int i = 0; i < count; i++) {
      deleteButtons.add(IconButton(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        constraints: const BoxConstraints(),
        onPressed: () {
          setState(() {
            exercise.reps.removeAt(i);
            exercise.weights.removeAt(i);
          });
        },
        icon: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 117, 16, 9),
          size: 25,
        ),
      ));
    }
    return deleteButtons;
  }
}
