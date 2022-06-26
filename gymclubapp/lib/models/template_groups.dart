import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String name;
  String description;
  List<WorkoutTemplate> items;

  TemplateGroup({
    required this.name,
    required this.description,
    required this.items,
  });

  void addTemplate(WorkoutTemplate template) {
    items.add(template);
  }
}
