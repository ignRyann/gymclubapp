// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:gymclubapp/screens/screens.dart';
import '../../utils/widgets.dart';
import '../../services/auth_services.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  // Tab Bar Controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] Profile App Bar
    final profileAppBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'PROFILE',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            splashRadius: 20,
            onPressed: () {
              // TODO Create Profile Settings
              print("Profile Settings has been pressed.");
            },
            icon: const Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ))
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

    // [Widget] Profile Picture
    final profilePicture = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.3,
          vertical: MediaQuery.of(context).size.width * 0.05),
      child: ClipOval(
        child: Image.network(
            'https://cdn.pixabay.com/photo/2020/11/04/07/52/pumpkin-5711688_960_720.jpg'),
      ),
    );

    // [Widget] Tab Bar DefaultTabController
    final tabBar = TabBar(
      controller: _tabController,
      tabs: const [
        Tab(
          text: "Profile",
        ),
        Tab(
          text: "Logs",
        ),
      ],
      labelColor: Colors.white,
      indicator: MaterialIndicator(
        horizontalPadding: MediaQuery.of(context).size.width * 0.1,
        color: Colors.white,
        paintingStyle: PaintingStyle.fill,
      ),
    );

    final tabBarView = SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Center(
              child: Text("Profile Page"),
            ),
            Center(
              child: Text("Logs Page"),
            )
          ],
        ));

    // Main Body
    return Scaffold(
      appBar: profileAppBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: gradientDesign()),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    profilePicture,
                    signOut,
                    tabBar,
                    tabBarView,
                  ],
                ))),
      ),
    );
  }
}
