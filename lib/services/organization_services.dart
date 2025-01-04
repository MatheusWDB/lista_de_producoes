import 'package:todo_list_2/models/todo.dart';

class OrganizationServices {

  void alphabeticalOrderAscending(List<Todo> toDoList) {
    toDoList
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }

  void alphabeticalOrderDescending(List<Todo> toDoList) {
    toDoList
        .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
  }

  void watched(List<Todo> toDoList) {
    toDoList.sort((a, b) {
      if (!a.ok && b.ok) {
        return 1;
      } else if (a.ok && !b.ok) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
  }

  void unwatched(List<Todo> toDoList) {
    toDoList.sort((a, b) {
      if (a.ok && !b.ok) {
        return 1;
      } else if (!a.ok && b.ok) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
  }

  void categoryAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.category
        .toString()
        .toLowerCase()
        .compareTo(b.category.toString().toLowerCase()));
  }

  void categoryDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.category
        .toString()
        .toLowerCase()
        .compareTo(a.category.toString().toLowerCase()));
  }

  void streamingServiceAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(b.streaming.first.toString().toLowerCase()));
  }

  void streamingServiceDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(a.streaming.first.toString().toLowerCase()));
  }

  void accessModeAscending(List<Todo> toDoList) {
    toDoList.sort((a, b) => a.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(b.streaming.first.toString().split(' - ')[1].toLowerCase()));
  }

  void accessModeDescending(List<Todo> toDoList) {
    toDoList.sort((a, b) => b.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(a.streaming.first.toString().split(' - ')[1].toLowerCase()));
  }
}
