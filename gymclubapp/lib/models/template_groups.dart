import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String name;
  String description;
  List<Template> templates = [];

  TemplateGroup({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toFireStore() {
    List templateNames = [];
    for (Template template in templates) {
      templateNames.add(template.name);
    }
    return {
      "name": name,
      "description": description,
      "templateNames": templateNames,
    };
  }

  void addTemplate(Template template) {
    templates.add(template);
  }
}
