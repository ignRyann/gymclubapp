import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/general/home.dart';
import 'package:gymclubapp/services/template_services.dart';
import 'package:gymclubapp/utils/utils.dart';

class AddTemplateGroup extends StatefulWidget {
  const AddTemplateGroup({Key? key}) : super(key: key);

  @override
  State<AddTemplateGroup> createState() => _AddTemplateGroupState();
}

class _AddTemplateGroupState extends State<AddTemplateGroup> {
  // Global Key
  final _templateKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Error Messages
  bool _groupNameAvailable = false;

  @override
  Widget build(BuildContext context) {
    // [Widget] AppBar
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'CREATE GROUP',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

    // [Widget] Template Group Name TextFormField
    final name = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty || value.length < 3 || value.length > 30) {
            return 'Group Name must be between 3 & 20 characters.';
          }
        }
        return null;
      }),
      controller: _nameController,
      enableSuggestions: false,
      autocorrect: true,
      autofocus: false,
      cursorColor: Colors.white,
      onChanged: (text) async {
        final groupNameAvailable =
            await TemplateService().groupNameAvailable(text);
        setState(() {
          _groupNameAvailable = groupNameAvailable;
        });
      },
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.dashboard,
            color: Colors.white70,
          ),
          suffixIcon: _groupNameAvailable
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
          labelText: 'Enter Group Name',
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
          labelText: 'Enter Group Description',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Create Template Group Button
    final createTemplateButton = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          if (_templateKey.currentState!.validate() && _groupNameAvailable) {
            await TemplateService()
                .createTemplateGroup(
                    _nameController.text, _descriptionController.text)
                .then((value) {
              value ? "Added Template Group" : "Error adding Template Group";
            }).then((value) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
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
          'CREATE',
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
        child: SingleChildScrollView(
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
                        createTemplateButton
                      ],
                    )))),
      ),
    );
  }
}
