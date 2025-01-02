import 'package:todo_list_2/enums/type_enum.dart';
import 'package:todo_list_2/models/streaming.dart';

class Todo {
  String title;
  TypeEnum type;
  List<Streaming> streaming;
  bool ok;
  DateTime date;

  Todo({
    required this.title,
    required this.type,
    required this.streaming,
    this.ok = false,
    required this.date,
  });

  // Converte o objeto Todo para um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type':
          type.displayName, // Assume que o TypeEnum tem o atributo displayName
      'streaming': streaming
          .map((s) => s.toJson())
          .toList(), // Converte cada Streaming para JSON
      'ok': ok,
      'date': date.toIso8601String(), // Converte o DateTime para string ISO8601
    };
  }

  // Converte um mapa (JSON) para um objeto Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      type: TypeEnum.values.firstWhere((e) => e.displayName == json['type']),
      streaming: (json['streaming'] as List)
          .map((e) => Streaming.fromJson(e as Map<String, dynamic>))
          .toList(), // Converte os itens de streaming para objetos Streaming
      ok: json['ok'] ?? false, // Se não houver o campo 'ok', assume false
      date: DateTime.parse(json['date']), // Converte a string para DateTime
    );
  }
}
