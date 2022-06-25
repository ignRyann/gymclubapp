import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String templateGroupName;
  String templateGroupDescription;
  List<WorkoutTemplate> templateGroupItems;

  TemplateGroup({
    required this.templateGroupName,
    required this.templateGroupDescription,
    required this.templateGroupItems,
  });

  void addTemplate(WorkoutTemplate template) {
    templateGroupItems.add(template);
  }
}
