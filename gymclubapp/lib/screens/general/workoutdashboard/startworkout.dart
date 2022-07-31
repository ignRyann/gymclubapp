import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/widgets.dart';

class StartWorkoutScreen extends StatefulWidget {
  final DashboardData dashboardData;
  final Workout workout;
  const StartWorkoutScreen(
      {Key? key, required this.dashboardData, required this.workout})
      : super(key: key);

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    // [Widget] Finish Workout IconButton
    final finishWorkoutButton = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(width: 2, color: Colors.white)),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 23,
              child: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.white,
                icon: const Icon(
                  Icons.post_add,
                  color: Colors.green,
                  size: 28,
                ),
                onPressed: () async {
                  widget.workout.post(widget.dashboardData.uid).then((value) {
                    Navigator.pop(context, widget.dashboardData.uid);
                  });

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ConfirmWorkoutScreen(
                  //             workout: widget.workout,
                  //           )),
                  // );
                },
              ),
            )));

    // [Widget] StartWorkoutScreen AppBar
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'WORKOUT',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      actions: [finishWorkoutButton],
    );

    // [Widget] Workout Title TextFormField
    final title = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Please enter a title for your workout';
          } else if (value.length > 30) {
            return 'Please shorten your title to 30 characters';
          }
        }
        return null;
      }),
      enableSuggestions: false,
      autocorrect: true,
      autofocus: false,
      cursorColor: Colors.white,
      onChanged: (text) {
        widget.workout.title = text;
      },
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.dashboard,
            color: Colors.white70,
          ),
          labelText: 'Enter Workout Title',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Workout Note TextField
    final note = TextField(
      maxLines: null,
      enableSuggestions: false,
      autocorrect: true,
      autofocus: false,
      onChanged: (text) {
        widget.workout.note = text;
      },
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.description,
            color: Colors.white70,
          ),
          labelText: 'Enter Workout Note',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Customise Workout Exercises Expanded
    final customiseWorkout = Theme(
        data: ThemeData(
            canvasColor: Colors.transparent, shadowColor: Colors.transparent),
        child: ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return exerciseLayout(index);
            },
            itemCount: widget.workout.exercises.length,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Exercise item =
                    widget.workout.exercises.removeAt(oldIndex);
                widget.workout.exercises.insert(newIndex, item);
              });
            }));

    // [Widget] Add Exercise Button
    final addExerciseButton = Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddExerciseScreen(
                      dashboardData: widget.dashboardData,
                    )),
          ).then(
            (exerciseName) {
              if (exerciseName != null) {
                setState(() {
                  widget.workout.addExercise(Exercise(
                      name: exerciseName, note: "", reps: [], weights: []));
                });
              }
            },
          );
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'ADD EXERCISE',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              title,
              const SizedBox(height: 20),
              note,
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Divider(color: Colors.white),
              ),
              const SizedBox(height: 10),
              customiseWorkout,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: addExerciseButton,
              )
            ],
          ),
        ),
      ),
    );
  }

  // [Function] Retrieve Exercise Layout
  Column exerciseLayout(int index) {
    // Variables
    Exercise exercise = widget.workout.exercises[index];
    final TextEditingController exerciseNoteController =
        TextEditingController(text: exercise.note);
    return Column(
      key: Key(index.toString()),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          widget.workout.exercises.remove(exercise);
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
              getSetsRepsWeightsLayout(exercise),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  // [Function] Retrieves the set / reps template
  Row getSetsRepsWeightsLayout(Exercise exercise) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Set Index
        Column(children: getSetIndexList(exercise.reps.length)),
        // Weights Value
        Column(children: getWeightsList(exercise)),
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

  // [Function] Get Weights List
  List<Widget> getWeightsList(Exercise exercise) {
    // Creating List
    List<Widget> weightsList = [
      const Text(
        "WEIGHTS",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
    ];
    // Iterating through each Weight
    for (int i = 0; i < exercise.weights.length; i++) {
      // Creating TextEditingController
      TextEditingController controller =
          TextEditingController(text: "${exercise.weights[i]}");
      controller.selection = TextSelection.fromPosition(TextPosition(
        offset: controller.text.length,
      ));

      // Creating Weights Container
      final weightsItem = Container(
        width: 80,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.4),
        ),
        // Weights TextField
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
            if (value.length > 5) {
              setState(() {
                controller.text = controller.text.substring(0, 3);
              });
            } else {
              exercise.weights[i] = value;
            }
          },
        ),
      );
      // Adding items to List
      weightsList.add(weightsItem);
      weightsList.add(const SizedBox(height: 10));
    }
    return weightsList;
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
