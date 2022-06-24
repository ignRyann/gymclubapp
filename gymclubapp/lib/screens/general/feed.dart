// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gymclubapp/utils/utils.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    // [Widget] AppBar
    final feedAppBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(
        'GYMCLUB',
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
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black87,
                  size: 25,
                )),
          ),
        ),
      ],
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
                  children: const <Widget>[
                    // logoWidget("images/dumbell.png", 120, 120),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                  ],
                ))),
      ),
    );
  }
}
