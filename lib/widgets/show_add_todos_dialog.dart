import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/models/streaming.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/services/storage_services.dart';

class ShowAddTodosDialog extends StatefulWidget {
  final List<Todo> toDoList;
  final VoidCallback onToDoListUpdated;
  final Locale myLocale;

  const ShowAddTodosDialog(
      {super.key,
      required this.toDoList,
      required this.onToDoListUpdated,
      required this.myLocale});

  @override
  State<ShowAddTodosDialog> createState() => _ShowAddTodosDialogState();
}

class _ShowAddTodosDialogState extends State<ShowAddTodosDialog> {
  final Map<String, dynamic> _toDoController = {
    'title': TextEditingController(),
    'category': CategoryEnum.absent,
    'streaming': <Streaming>[]
  };

  Map<String, dynamic> error = {
    'title': null,
    'category': null,
    'streamingService': null,
    'accessMode': [],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.newTitle),
      titleTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 28),
      content: Column(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _toDoController['title'],
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.title,
              errorText: error['title'],
              labelStyle: const TextStyle(
                color: Colors.blueAccent,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                error['title'] = null;
              });
            },
          ),
          SingleChildScrollView(
            child: DropdownMenu<CategoryEnum>(
              errorText: error['category'],
              initialSelection: _toDoController['category'],
              menuHeight: MediaQuery.of(context).size.height * 0.44,
              dropdownMenuEntries: CategoryEnum.values.map((category) {
                return DropdownMenuEntry(
                  value: category,
                  label: category.displayName,
                );
              }).toList(),
              onSelected: (newValue) {
                _toDoController['category'] = newValue;
                if (newValue != CategoryEnum.absent) {
                  setState(() {
                    error['category'] = null;
                  });
                }
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: error['streamingAccess'] == null
                      ? null
                      : const BorderSide(
                          color: Colors.red, // Espessura da borda
                        ),
                ),
                onPressed: () {
                  setState(() {
                    error['streamingService'] = null;
                  });
                  _showStreamingAccessDialog(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.availableOn,
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ),
              if (error['streamingService'] != null) ...[
                Text(
                  error['streamingService']!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            resetTodoController();
            resetError();
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_toDoController['title'].text.isEmpty) {
              setState(() {
                error['title'] = AppLocalizations.of(context)!.requiredField;
              });

              return;
            }
            if (_toDoController['category'] == CategoryEnum.absent) {
              setState(() {
                error['category'] = AppLocalizations.of(context)!.required;
              });

              return;
            }
            if (_toDoController['streaming'].isEmpty) {
              setState(() {
                error['streamingService'] =
                    AppLocalizations.of(context)!.required;
              });

              return;
            }
            _addToDo();
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.add,
            style: const TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  String capitalizeFirstLetter(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }

  void _addToDo() {
    List<Streaming> streaming = _toDoController['streaming'];

    streaming.sort((a, b) => a.streamingService.displayName
        .compareTo(b.streamingService.displayName));

    Todo newToDo = Todo(
      title: _toDoController['title'].text,
      date: DateTime.now().toLocal(),
      category: _toDoController['category'],
      streaming: streaming,
    );

    widget.toDoList.add(newToDo);
    StorageService().saveData(widget.toDoList);
    widget.onToDoListUpdated();
    resetTodoController();
    resetError();
  }

  void resetTodoController() {
    _toDoController['title']!.clear();
    _toDoController['category'] = CategoryEnum.absent;
    _toDoController['streaming'].clear();
  }

  void resetError() {
    error['title'] = null;
    error['category'] = null;
    error['streamingService'] = null;
    error['accessMode'].clear();
  }

  void _showStreamingAccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text(AppLocalizations.of(context)!.selectStreamingAndAccess),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        border: error['streamingService'] != null
                            ? Border.all(color: Colors.red, width: 1.5)
                            : null,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: StreamingEnum.values.map((streaming) {
                            final bool isSelected = _toDoController['streaming']
                                .any((entry) =>
                                    entry.streamingService == streaming);
                            final int index = _toDoController['streaming']
                                .indexWhere((entry) =>
                                    entry.streamingService == streaming);
                            error['accessMode'].add(null);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.0),
                                  ),
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Text(streaming.displayName),
                                        value: isSelected,
                                        onChanged: (selected) {
                                          setState(() {
                                            if (selected == true) {
                                              _toDoController['streaming'].add(
                                                  Streaming(
                                                      streamingService:
                                                          streaming,
                                                      accessMode:
                                                          AccessEnum.absent));
                                              error['streamingService'] = null;
                                            } else {
                                              _toDoController['streaming']
                                                  .removeAt(index);
                                            }
                                          });
                                        },
                                      ),
                                      if (isSelected)
                                        DropdownMenu<AccessEnum>(
                                          errorText: error['accessMode'][index],
                                          initialSelection: AccessEnum.absent,
                                          dropdownMenuEntries:
                                              AccessEnum.values.map((access) {
                                            return DropdownMenuEntry(
                                              value: access,
                                              label: access.displayName,
                                            );
                                          }).toList(),
                                          onSelected: (newValue) {
                                            setState(() {
                                              _toDoController['streaming']
                                                  [index] = Streaming(
                                                streamingService: streaming,
                                                accessMode: newValue,
                                              );
                                              error['accessMode'][index] = null;
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  if (error['streamingService'] != null) ...[
                    Text(
                      error['streamingService'],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _toDoController['streaming'].clear();
                    resetError();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.back,
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_toDoController['streaming'].isEmpty) {
                      setState(() {
                        error['streamingService'] =
                            AppLocalizations.of(context)!.chooseAtLeastOne;
                      });
                      return;
                    }
                    int errors = 0;

                    for (Streaming element in _toDoController['streaming']) {
                      final int index =
                          _toDoController['streaming'].indexOf(element);

                      if (element.accessMode == AccessEnum.absent) {
                        setState(() {
                          error['accessMode'][index] =
                              AppLocalizations.of(context)!.required;
                        });

                        errors++;
                      }
                    }
                    if (errors != 0) return;
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
