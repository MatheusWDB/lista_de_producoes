import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/models/todo.dart';

class FilteringServices {
  List<Todo> filterByWatched(List<Todo> toDoList) {
    return toDoList.where((todo) => todo.ok).toList();
  }

  List<Todo> filterByUnwatched(List<Todo> toDoList) {
    return toDoList.where((todo) => !todo.ok).toList();
  }

  List<Todo> filterByCategory(List<Todo> toDoList, CategoryEnum category) {
    return toDoList.where((todo) => todo.category == category).toList();
  }

  List<Todo> filterByStreamingService(
      List<Todo> toDoList, StreamingEnum streamingService) {
    return toDoList
        .where((todo) => todo.streaming
            .any((streaming) => streaming.streamingService == streamingService))
        .toList();
  }

  List<Todo> filterByAccessMode(List<Todo> toDoList, AccessEnum accessMode) {
    return toDoList
        .where((todo) => todo.streaming
            .any((streaming) => streaming.accessMode == accessMode))
        .toList();
  }
}
