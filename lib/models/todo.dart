import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/enums/genre_enum.dart';
import 'package:todo_list_2/models/streaming.dart';

class Todo {
  String title;
  CategoryEnum category;
  List<GenreEnum> genre;
  List<Streaming> streaming;
  bool watched;
  DateTime date;
  bool isDeleted;

  Todo({
    required this.title,
    required this.category,
    this.genre = const [],
    required this.streaming,
    this.watched = false,
    required this.date,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category.displayName,
      'genre': genre.map((g) => g.displayName).toList(),
      'streaming': streaming.map((s) => s.toJson()).toList(),
      'watched': watched,
      'date': date.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      category: CategoryEnum.values
          .firstWhere((e) => e.displayName == json['category']),
      genre: (json['genre'] as List?)
              ?.map(
                  (e) => GenreEnum.values.firstWhere((e) => e.displayName == e))
              .toList() ??
          [], // Corrigido: trata como lista de enum
      streaming: (json['streaming'] as List)
          .map((e) => Streaming.fromJson(e as Map<String, dynamic>))
          .toList(),
      watched: json['watched'] ?? false,
      date: DateTime.parse(json['date']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
