// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class EditTemplateScreen extends StatefulWidget {
  final String userUID;
  final TemplateGroup templateGroup;
  final Template template;
  const EditTemplateScreen({
    Key? key,
    required this.userUID,
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

    // [Widget] Template Group Name TextFormField
    final name = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty || value.length < 3 || value.length > 30) {
            return 'Template Name must be between 3 & 30 characters.';
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
      maxLines: 3,
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

    // [Widget] Customise Template Exercises Expanded
    final customiseTemplate = Expanded(
      child: Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return exerciseLayout(widget.template, index);
            },
            itemCount: widget.template.exerciseCount,
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

    // [Widget] Save Template Group Button
    final saveTemplateButton = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          if (_templateKey.currentState!.validate() && _templateNameAvailable) {
            await widget.templateGroup
                .editTemplate(widget.userUID, widget.template,
                    _nameController.text, _descriptionController.text)
                .then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            userUID: widget.userUID,
                          )));
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: Form(
            key: _templateKey,
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 40),
                child: Column(
                  children: <Widget>[
                    name,
                    const SizedBox(height: 20),
                    description,
                    const SizedBox(height: 20),
                    customiseTemplate,
                    saveTemplateButton
                  ],
                ))),
      ),
    );
  }

  // [Function] Retrieve Exercise Layout
  Column exerciseLayout(Template template, int index) {
    // Variables
    Exercise exercise = template.exercises[index];
    final TextEditingController exerciseNoteController =
        TextEditingController(text: exercise.note);
    return Column(
      key: Key(index.toString()),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black26,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Exercise Name
                  Text(
                    exercise.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  // Delete Icon
                  IconButton(
                    onPressed: () {
                      print("Delete ${exercise.name} button has been pressed");
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: exerciseNoteController,
                enableSuggestions: false,
                autofocus: false,
                maxLines: null,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.amber),
                decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(0.1),
                  prefixIcon: const Icon(
                    Icons.edit_note_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  labelText: 'Enter Exercise Note',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      )),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
