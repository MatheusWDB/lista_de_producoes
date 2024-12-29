class Todo {
  String title;
  bool ok = false;
  DateTime date;

  Todo({
    required this.title,
    required this.ok,
    required this.date,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        ok = json['ok'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ok': ok,
      'date': date.toIso8601String(),
    };
  }
}
