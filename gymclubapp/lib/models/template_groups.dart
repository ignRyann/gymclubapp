import 'package:gymclubapp/models/models.dart';

class TemplateGroup {
  String name;
  String description;
  List<Template> templates = [];

  TemplateGroup({
    required this.name,
    required this.description,
  });

  void addTemplate(Template template) {
    templates.add(template);
  }
}
