class Todo {
  String title;
  String description;
  bool ok = false;
  DateTime date;

  Todo({
    required this.title,
    this.description = '',
    required this.ok,
    required this.date,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        ok = json['ok'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ok': ok,
      'date': date.toIso8601String(),
    };
  }
}
