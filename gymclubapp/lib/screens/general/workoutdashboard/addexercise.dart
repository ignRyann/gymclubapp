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

    final tabBarView = Expanded(
        child: TabBarView(
      controller: _tabController,
      children: <Widget>[
        retrieveTabView("all"),
        retrieveTabView("weights"),
        retrieveTabView("machines"),
        retrieveTabView("other"),
      ],
    ));

    // Main Body
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

  // [Function] Retrieves Tab Bar View for each category
  Container retrieveTabView(String category) {
    // Dictates what the list items are
    List<ExerciseItem> exercises = [];
    if (category == "all") {
      exercises = widget.dashboardData.exerciseList;
    } else {
      exercises = widget.dashboardData.getExercises(category);
    }
    // Tab Bar View Container
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Expanded(
          // Exercise List Builder
          child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          // Exercise Item Container
          return exerciseLayout(exercises[index]);
        },
      )),
    );
  }

  // [Function] Retrieves ExerciseItemLayout
  Container exerciseLayout(ExerciseItem exercise) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      color: Colors.black26,
      child: Center(
          child: Text(
        exercise.name,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }
}
