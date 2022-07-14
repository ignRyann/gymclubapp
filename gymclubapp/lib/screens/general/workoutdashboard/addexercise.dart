import 'package:flutter/material.dart';
import 'package:gymclubapp/models/models.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../utils/utils.dart';

class AddExerciseScreen extends StatefulWidget {
  final DashboardData dashboardData;
  const AddExerciseScreen({Key? key, required this.dashboardData})
      : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen>
    with TickerProviderStateMixin {
  // Tab Bar Controller
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // [Widget] AppBar
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: const Text(
        'Add Exercise',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

    // [Widget] Tab Bar DefaultTabController
    final tabBar = TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "All"),
        Tab(text: "Weights"),
        Tab(text: "Machines"),
        Tab(text: "Other"),
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
              child: Text(
                "All Exercises",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "Freeweight Exercises",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "Machines",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "Other",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));

    return Scaffold(
        appBar: appBar,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(gradient: gradientDesign()),
            child: Column(
              children: <Widget>[
                tabBar,
                tabBarView,
              ],
            )));
  }
}
