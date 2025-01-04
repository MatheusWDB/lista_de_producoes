import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/services/filtering_services.dart';
import 'package:todo_list_2/services/organization_services.dart';
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
  StorageServices storageServices = StorageServices();
  OrganizationServices organizationServices = OrganizationServices();
  FilteringServices filteringServices = FilteringServices();

  String filter = 'all';
  CategoryEnum? filterByCategory;
  StreamingEnum? filterByStreamingService;
  AccessEnum? filterByAccessMode;

  List<Todo> _toDoList = [];

  Todo? _deletedTodo;
  int? _deletedTodoIndex;
  late Locale myLocale;

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      myLocale = Localizations.localeOf(context);
    });

    final List<Todo> filteredList = switch (filter) {
      'watched' => filteringServices.filterByWatched(_toDoList),
      'unwatched' => filteringServices.filterByUnwatched(_toDoList),
      'category' =>
        filteringServices.filterByCategory(_toDoList, filterByCategory!),
      'streaming' => filteringServices.filterByStreamingService(
          _toDoList, filterByStreamingService!),
      'access' =>
        filteringServices.filterByAccessMode(_toDoList, filterByAccessMode!),
      _ => _toDoList,
    };

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homePageTitle),
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
              Text(AppLocalizations.of(context)!.completedTitles(
                  _toDoList.where((todo) => todo.ok == true).length,
                  _toDoList.length)),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          spacing: 5.0,
                          children: [
                            for (Todo todo in filteredList)
                              TodoItem(
                                todo: todo,
                                toDoList: _toDoList,
                                onChanged: (value) {
                                  setState(() {
                                    _toDoList
                                        .firstWhere(
                                            (element) => element == todo)
                                        .ok = value!;
                                    storageServices.saveData(_toDoList);
                                  });
                                },
                                onDelete: onDelete,
                              ),
                          ],
                        )
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
                      fixedSize: Size(135, 50),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.clearAll,
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
                      fixedSize: Size(135, 50),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.newTitle,
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
      storageServices.saveData(_toDoList);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.titleRemoved(todo.title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            setState(() {
              _toDoList.insert(_deletedTodoIndex!, _deletedTodo!);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.actionUndone,
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
            storageServices.saveData(_toDoList);
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
              myLocale: myLocale,
            ));
  }

  void showDeleteTodosConfirmationDialog() {
    if (_toDoList.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.clearAllConfirmation,
          ),
          content: Text(
            AppLocalizations.of(context)!.noTitles,
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text(AppLocalizations.of(context)!.close),
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
        myLocale: myLocale,
      ),
    );
  }

  void readData() {
    storageServices.readData().then((data) {
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
      storageServices.saveData(_toDoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      readData();
    });
    return null;
  }
}
