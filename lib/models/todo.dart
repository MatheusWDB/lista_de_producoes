import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/models/streaming.dart';

class Todo {
  String title;
  CategoryEnum category;
  List<Streaming> streaming;
  bool ok;
  DateTime date;
  bool isDeleted;

  Todo({
    required this.title,
    required this.category,
    required this.streaming,
    this.ok = false,
    required this.date,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.displayName,
      'streaming': streaming.map((s) => s.toJson()).toList(),
      'ok': ok,
      'date': date.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      category: CategoryEnum.values
          .firstWhere((e) => e.displayName == json['category']),
      streaming: (json['streaming'] as List)
          .map((e) => Streaming.fromJson(e as Map<String, dynamic>))
          .toList(),
      ok: json['ok'] ?? false,
      date: DateTime.parse(json['date']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
