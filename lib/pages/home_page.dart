import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/services/storage_services.dart';
import 'package:todo_list_2/widgets/show_add_todos_dialog.dart';
import 'package:todo_list_2/widgets/show_delete_todos_confirmation_dialog.dart';
import 'package:todo_list_2/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StorageService storageService = StorageService();

  List<Todo> _toDoList = [];

  Todo? _deletedTodo;
  int? _deletedTodoIndex;
  Locale? myLocale;

  @override
  void initState() {
    super.initState();
    // Espera até que o contexto esteja pronto para acessar o Locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myLocale = Localizations.localeOf(context);
    });
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(myLocale?.languageCode == 'pt' ? 'Minha Lista' : 'My List'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12.0,
            children: [
              Text(
                  '${_toDoList.where((todo) => todo.ok == true).length}/${_toDoList.length}'),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Todo todo in _toDoList)
                          TodoItem(
                            todo: todo,
                            onChanged: (value) {
                              setState(() {
                                todo.ok = value!;
                                storageService.saveData(_toDoList);
                              });
                            },
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(
                      myLocale?.languageCode == 'pt'
                          ? 'Limpar Tudo'
                          : 'Clear All',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: showAddTodosDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(
                      myLocale?.languageCode == 'pt'
                          ? 'Novo Título...'
                          : 'New Title...',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    _deletedTodo = todo;
    _deletedTodoIndex = _toDoList.indexOf(todo);

    setState(() {
      _toDoList.remove(todo);
      storageService.saveData(_toDoList);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          myLocale?.languageCode == 'pt'
              ? 'O titúlo "${todo.title}" foi removida com sucesso!'
              : 'The title "${todo.title}" has been removed successfully!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _toDoList.insert(_deletedTodoIndex!, _deletedTodo!);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    myLocale?.languageCode == 'pt'
                        ? 'Ação desfeita!'
                        : 'Action undone!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
            storageService.saveData(_toDoList);
          },
          textColor: Colors.blueAccent,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showAddTodosDialog() {
    showDialog(
        context: context,
        builder: (context) => ShowAddTodosDialog(
              toDoList: _toDoList,
              onToDoListUpdated: () {
                setState(() {
                  readData();
                });
              },
              myLocale: myLocale!,
            ));
  }

  void showDeleteTodosConfirmationDialog() {
    if (_toDoList.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            myLocale?.languageCode == 'pt' ? 'Limpar Tudo?' : 'Clear All?',
          ),
          content: Text(
            myLocale?.languageCode == 'pt'
                ? 'Você não possui títulos cadastrados!'
                : 'You do not have registered titles!',
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child:
                  Text(myLocale?.languageCode == 'pt' ? 'Fechar' : 'To close'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ShowDeleteTodosConfirmationDialog(
        context: context,
        deleteAllTodos: deleteAllTodos,
        myLocale: myLocale!,
      ),
    );
  }

  void readData() {
    storageService.readData().then((data) {
      setState(() {
        if (data != null) {
          // Decodifica a string JSON para uma lista de mapas
          List<dynamic> decodedData = json.decode(data);

          // Mapeia cada mapa para um objeto Todo
          _toDoList = decodedData.map((item) => Todo.fromJson(item)).toList();
        }
      });
    });
  }

  void deleteAllTodos() {
    setState(() {
      _toDoList.clear();
      storageService.saveData(_toDoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    storageService.organize(_toDoList);

    setState(() {
      storageService.saveData(_toDoList);
    });

    return null;
  }
}
