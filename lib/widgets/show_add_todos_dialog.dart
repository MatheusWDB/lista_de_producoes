import 'package:flutter/material.dart';
import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/enums/type_enum.dart';
import 'package:todo_list_2/models/streaming.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/services/storage_services.dart';

class ShowAddTodosDialog extends StatefulWidget {
  final List<Todo> toDoList;
  final VoidCallback onToDoListUpdated;

  const ShowAddTodosDialog(
      {super.key, required this.toDoList, required this.onToDoListUpdated});

  @override
  State<ShowAddTodosDialog> createState() => _ShowAddTodosDialogState();
}

class _ShowAddTodosDialogState extends State<ShowAddTodosDialog> {
  final Map<String, dynamic> _toDoController = {
    'title': TextEditingController(),
    'type': TypeEnum.absent,
    'streaming': <Streaming>[]
  };

  Map<String, dynamic> error = {
    'title': null,
    'type': null,
    'streamingService': null,
    'accessMode': [],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Novo Título...'),
      titleTextStyle: TextStyle(color: Colors.blueAccent, fontSize: 28),
      content: Column(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _toDoController['title'],
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              labelText: 'Título',
              errorText: error['title'],
              labelStyle: TextStyle(
                color: Colors.blueAccent,
              ),
              focusedBorder: UnderlineInputBorder(
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
            child: DropdownMenu<TypeEnum>(
              errorText: error['type'],
              initialSelection: _toDoController['type'],
              menuHeight: MediaQuery.of(context).size.height * 0.44,
              dropdownMenuEntries: TypeEnum.values.map((type) {
                return DropdownMenuEntry(
                  value: type,
                  label: type.displayName,
                );
              }).toList(),
              onSelected: (newValue) {
                _toDoController['type'] = newValue;
                if (newValue != TypeEnum.absent) {
                  setState(() {
                    error['type'] = null;
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
                      : BorderSide(
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
                  'Disponível em...',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              if (error['streamingService'] != null) ...[
                Text(
                  error['streamingService']!,
                  style: TextStyle(
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
            'Cancelar',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (_toDoController['title'].text.isEmpty) {
                error['title'] = 'Campo obrigatório!';
                return;
              }
              if (_toDoController['type'] == TypeEnum.absent) {
                error['type'] = 'Obrigatório!';
                return;
              }
              if (_toDoController['streaming'].isEmpty) {
                error['streamingService'] = 'Obrigatório!';
                return;
              }
              _addToDo();
            });
          },
          child: Text(
            'Adicionar',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  String capitalizeFirstLetter(String text) {
    return text
        .split(' ') // Divide a string em palavras
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }

  void _addToDo() {
    Todo newToDo = Todo(
      title: capitalizeFirstLetter(_toDoController['title'].text),
      date: DateTime.now().toLocal(),
      type: _toDoController['type'],
      streaming: _toDoController['streaming'],
    );

    widget.toDoList.add(newToDo);
    StorageService().saveData(widget.toDoList);
    widget.onToDoListUpdated();
    resetTodoController();
    resetError();
    Navigator.of(context).pop();
  }

  void resetTodoController() {
    _toDoController['title']!.clear();
    _toDoController['type'] = TypeEnum.absent;
    _toDoController['streaming'].clear();
  }

  void resetError() {
    error['title'] = null;
    error['type'] = null;
    error['streamingService'] = null;
    error['accsesMode'].clear();
  }

  void _showStreamingAccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Selecione Streaming e o tipo de Acesso'),
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
                      style: TextStyle(
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
                    'Voltar',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_toDoController['streaming'].isEmpty) {
                      setState(() {
                        error['streamingService'] = 'Escolha ao menos um!';
                      });
                      return;
                    }
                    int errors = 0;

                    for (Streaming element in _toDoController['streaming']) {
                      final int index =
                          _toDoController['streaming'].indexOf(element);

                      if (element.accessMode == AccessEnum.absent) {
                        setState(() {
                          error['accessMode'][index] = 'Obrigatório';
                        });

                        errors++;
                      }
                    }
                    if (errors != 0) return;
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
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
