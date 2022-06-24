import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/colour_utils.dart';
import '../../utils/widgets.dart';
import '../auth_services.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // [Widget] AppBar
    final feedAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(
        'WORKOUT',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 22,
            child: IconButton(
                onPressed: (() {
                  print("Notifications Button Pressed");
                }),
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black87,
                  size: 25,
                )),
          ),
        ),
      ],
    );

    // [Widget] Sign Out Elevated Button
    final signOut = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          AuthService().signOut(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'SIGN OUT',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: feedAppBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                child: Column(
                  children: <Widget>[
                    // logoWidget("images/dumbell.png", 120, 120),
                    const Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 120),
                    signOut,
                  ],
                ))),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: hexStringToColor("000000"),
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.person_outline, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          switch (index) {
            case 0:
              print("Home Page");
              break;
            case 1:
              print("Workout Page");
              // https://pub.dev/packages/modal_bottom_sheet
              break;
            case 2:
              print("Profile Page");
              break;
            default:
              print("Oh No!");
              break;
          }
        },
      ),
    );
  }
}
