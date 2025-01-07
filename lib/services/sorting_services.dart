import 'package:todo_list_2/models/todo.dart';

class SortingServices {
  List<Todo> dateOfCreationAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.date.compareTo(b.date));
    return toDoList;
  }

  List<Todo> dateOfCreationDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.date.compareTo(a.date));
    return toDoList;
  }

  List<Todo> alphabeticalOrderAscending(List<Todo> toDoList) {
    toDoList
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return toDoList;
  }

  List<Todo> alphabeticalOrderDescending(List<Todo> toDoList) {
    toDoList
        .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return toDoList;
  }

  List<Todo> watched(List<Todo> toDoList) {
    toDoList.sort((a, b) {
      if (!a.watched && b.watched) {
        return 1;
      } else if (a.watched && !b.watched) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return toDoList;
  }

  List<Todo> unwatched(List<Todo> toDoList) {
    toDoList.sort((a, b) {
      if (a.watched && !b.watched) {
        return 1;
      } else if (!a.watched && b.watched) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return toDoList;
  }

  List<Todo> categoryAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.category
        .toString()
        .toLowerCase()
        .compareTo(b.category.toString().toLowerCase()));
    return toDoList;
  }

  List<Todo> categoryDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.category
        .toString()
        .toLowerCase()
        .compareTo(a.category.toString().toLowerCase()));
    return toDoList;
  }

  List<Todo> streamingServiceAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(b.streaming.first.toString().toLowerCase()));
    return toDoList;
  }

  List<Todo> streamingServiceDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(a.streaming.first.toString().toLowerCase()));
    return toDoList;
  }

  List<Todo> accessModeAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(b.streaming.first.toString().split(' - ')[1].toLowerCase()));
    return toDoList;
  }

  List<Todo> accessModeDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(a.streaming.first.toString().split(' - ')[1].toLowerCase()));
    return toDoList;
  }
}
