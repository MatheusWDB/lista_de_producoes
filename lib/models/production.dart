import 'package:list_of_productions/enums/category_enum.dart';
import 'package:list_of_productions/enums/genre_enum.dart';
import 'package:list_of_productions/models/streaming.dart';

class Production {
  String title;
  CategoryEnum category;
  List<GenreEnum> genre;
  List<Streaming> streaming;
  bool watched;
  DateTime date;
  bool isDeleted;

  Production({
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
      'category': category.name,
      'genre': genre.map((g) => g.name).toList(),
      'streaming': streaming.map((s) => s.toJson()).toList(),
      'watched': watched,
      'date': date.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory Production.fromJson(Map<String, dynamic> json) {
    return Production(
      title: json['title'],
      category:
          CategoryEnum.values.firstWhere((c) => c.name == json['category']),
      genre: (json['genre'] as List)
          .map((e) => GenreEnum.values.firstWhere((g) => g.name == e))
          .toList(),
      streaming: (json['streaming'] as List)
          .map((s) => Streaming.fromJson(s as Map<String, dynamic>))
          .toList(),
      watched: json['watched'],
      date: DateTime.parse(json['date']),
      isDeleted: json['isDeleted'],
    );
  }

  @override
  String toString() {
    return '{title: "$title", category: "$category", genre: $genre, streaming: $streaming, watched: $watched, date: $date, isDeleted: $isDeleted';
  }
}
