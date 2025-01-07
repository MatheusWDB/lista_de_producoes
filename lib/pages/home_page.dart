import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/enums/filter_enum.dart';
import 'package:todo_list_2/enums/sort_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/services/filtering_services.dart';
import 'package:todo_list_2/services/sorting_services.dart';
import 'package:todo_list_2/services/storage_services.dart';
import 'package:todo_list_2/widgets/popup_menu_filtering.dart';
import 'package:todo_list_2/widgets/popup_menu_sorting.dart';
import 'package:todo_list_2/widgets/show_add_todos_dialog.dart';
import 'package:todo_list_2/widgets/show_delete_todos_confirmation_dialog.dart';
import 'package:todo_list_2/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageServices storageServices = StorageServices();
  final SortingServices sortingServices = SortingServices();
  final FilteringServices filteringServices = FilteringServices();

  FilterEnum filter = FilterEnum.all;
  SortEnum sort = SortEnum.date;
  bool ascending = true;

  CategoryEnum filterByCategory = CategoryEnum.absent;
  StreamingEnum filterByStreamingService = StreamingEnum.absent;
  AccessEnum filterByAccessMode = AccessEnum.absent;

  final Map<String, String?> error = {
    'sort': null,
    'filter': null,
  };

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

    List<Todo> renderedList = _toDoList;

    renderedList = switch (sort) {
      SortEnum.date => ascending == true
          ? sortingServices.dateOfCreationAscending(_toDoList)
          : sortingServices.dateOfCreationDescending(_toDoList),
      SortEnum.watched => ascending == true
          ? sortingServices.watched(_toDoList)
          : sortingServices.unwatched(_toDoList),
      SortEnum.alphabeticalOrder => ascending == true
          ? sortingServices.alphabeticalOrderAscending(_toDoList)
          : sortingServices.alphabeticalOrderDescending(_toDoList),
      SortEnum.category => ascending == true
          ? sortingServices.categoryAscending(_toDoList)
          : sortingServices.categoryDescending(_toDoList),
      SortEnum.streaming => ascending == true
          ? sortingServices.streamingServiceAscending(_toDoList)
          : sortingServices.streamingServiceDescending(_toDoList),
      SortEnum.access => ascending == true
          ? sortingServices.accessModeAscending(_toDoList)
          : sortingServices.accessModeDescending(_toDoList),
    };

    renderedList = switch (filter) {
      FilterEnum.all => _toDoList,
      FilterEnum.watched => filteringServices.filterByWatched(_toDoList),
      FilterEnum.unwatched => filteringServices.filterByUnwatched(_toDoList),
      FilterEnum.category =>
        filteringServices.filterByCategory(_toDoList, filterByCategory),
      FilterEnum.streaming => filteringServices.filterByStreamingService(
          _toDoList, filterByStreamingService),
      FilterEnum.access =>
        filteringServices.filterByAccessMode(_toDoList, filterByAccessMode),
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 249, 255),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuSorting(
                      sort: sort,
                      ascending: ascending,
                      onSelected: (value) {
                        setState(() {
                          if (sort == value) {
                            ascending = !ascending;
                            return;
                          }
                          ascending == false ? ascending = true : null;
                          sort = value as SortEnum;
                        });
                      }),
                  PopupMenuFiltering(
                    filter: filter,
                    onSelected: (value) {
                      if (value != FilterEnum.category &&
                          value != FilterEnum.streaming &&
                          value != FilterEnum.access) {
                        setState(() {
                          filter = value as FilterEnum;
                        });
                      }
                    },
                    filterByCategory: filterByCategory,
                    filterByStreamingService: filterByStreamingService,
                    filterByAccessMode: filterByAccessMode,
                    onSelectedByEnum: onSelectedByEnum,
                  )
                ],
              ),
              Text(AppLocalizations.of(context)!.completedTitles(
                  _toDoList.where((todo) => todo.watched == true).length,
                  _toDoList.length)),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 232, 255),
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
                            for (Todo todo in renderedList)
                              TodoItem(
                                todo: todo,
                                toDoList: _toDoList,
                                onChanged: (value) {
                                  setState(() {
                                    _toDoList
                                        .firstWhere(
                                            (element) => element == todo)
                                        .watched = value!;
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
                      fixedSize: const Size(135, 50),
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
                      fixedSize: const Size(135, 50),
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

  void onSelectedByEnum(Enum valueEnum, FilterEnum value) {
    setState(() {
      filter = value;
      switch (valueEnum) {
        case CategoryEnum _:
          filterByCategory = valueEnum;
          break;
        case StreamingEnum _:
          filterByStreamingService = valueEnum;
          break;
        case AccessEnum _:
          filterByAccessMode = valueEnum;
          break;
        case _:
          break;
      }
    });
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
