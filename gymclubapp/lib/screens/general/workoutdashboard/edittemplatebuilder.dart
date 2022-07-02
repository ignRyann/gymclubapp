// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class EditTemplateBuilder extends StatefulWidget {
  const EditTemplateBuilder({Key? key}) : super(key: key);

  @override
  State<EditTemplateBuilder> createState() => _EditTemplateBuilderState();
}

class _EditTemplateBuilderState extends State<EditTemplateBuilder> {
  List<List> data = [
    ['Dumbell Bench Press', 9, 15, 15],
    ['Barbell Bench Press', 8, 12, 12],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Theme(
        data: ThemeData(canvasColor: Colors.blue),
        child: ReorderableListView.builder(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          onReorder: onReorder,
        ),
      ),
    );
  }
}
