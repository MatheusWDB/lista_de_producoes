import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:list_of_productions/enums/access_enum.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';
import 'package:list_of_productions/enums/category_enum.dart';
import 'package:list_of_productions/models/streaming.dart';
import 'package:list_of_productions/models/production.dart';
import 'package:list_of_productions/services/storage_services.dart';

class AddProductionDialog extends StatefulWidget {
  final List<Production> productionList;
  final VoidCallback readListOfProductions;
  final Locale myLocale;

  const AddProductionDialog(
      {super.key,
      required this.productionList,
      required this.readListOfProductions,
      required this.myLocale});

  @override
  State<AddProductionDialog> createState() => _AddProductionDialogState();
}

class _AddProductionDialogState extends State<AddProductionDialog> {
  final Map<String, dynamic> productionController = {
    'title': TextEditingController(),
    'category': CategoryEnum.absent,
    'streaming': <Streaming>[]
  };

  final Map<String, dynamic> error = {
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
      content: Container(
        constraints: const BoxConstraints(maxWidth: 0),
        child: Column(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productionController['title'],
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
              child: DropdownMenu(
                errorText: error['category'],
                initialSelection: productionController['category'],
                menuHeight: MediaQuery.of(context).size.height * 0.44,
                dropdownMenuEntries: CategoryEnum.values.map((category) {
                  return DropdownMenuEntry(
                    value: category,
                    label: category.displayNameTranslate(context),
                  );
                }).toList(),
                onSelected: (newValue) {
                  productionController['category'] = newValue;
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
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            resetProductionController();
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
            if (productionController['title'].text.isEmpty) {
              setState(() {
                error['title'] = AppLocalizations.of(context)!.requiredField;
              });

              return;
            }
            if (productionController['category'] == CategoryEnum.absent) {
              setState(() {
                error['category'] = AppLocalizations.of(context)!.required;
              });

              return;
            }
            if (productionController['streaming'].isEmpty ||
                productionController['streaming']
                    .any((e) => e.accessMode == AccessEnum.absent)) {
              setState(() {
                error['streamingService'] =
                    AppLocalizations.of(context)!.required;
              });

              return;
            }
            addProduction();
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

  void addProduction() {
    List<Streaming> streaming = productionController['streaming'];

    streaming.sort((a, b) => a.streamingService
        .displayNameTranslate(context)
        .compareTo(b.streamingService.displayNameTranslate(context)));

    Production newProduction = Production(
      title: productionController['title'].text,
      date: DateTime.now().toLocal(),
      category: productionController['category'],
      streaming: streaming,
    );

    widget.productionList.add(newProduction);
    StorageServices().saveData(widget.productionList);
    widget.readListOfProductions();
    resetProductionController();
    resetError();
    Navigator.of(context).pop();
  }

  void resetProductionController() {
    productionController['title']!.clear();
    productionController['category'] = CategoryEnum.absent;
    productionController['streaming'].clear();
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
                          children: StreamingEnum.values
                              .where((streaming) =>
                                  streaming != StreamingEnum.absent)
                              .map((streaming) {
                            final bool isSelected =
                                productionController['streaming'].any((entry) =>
                                    entry.streamingService == streaming);
                            final int index = productionController['streaming']
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
                                        title: Text(streaming
                                            .displayNameTranslate(context)),
                                        value: isSelected,
                                        onChanged: (selected) {
                                          setState(() {
                                            if (selected == true) {
                                              productionController['streaming']
                                                  .add(Streaming(
                                                      streamingService:
                                                          streaming,
                                                      accessMode:
                                                          AccessEnum.absent));
                                              error['streamingService'] = null;
                                            } else {
                                              productionController['streaming']
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
                                              label:
                                                  access.displayNameTranslate(
                                                      context),
                                            );
                                          }).toList(),
                                          onSelected: (newValue) {
                                            setState(() {
                                              productionController['streaming']
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
                    productionController['streaming'].clear();
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
                    if (productionController['streaming'].isEmpty) {
                      setState(() {
                        error['streamingService'] =
                            AppLocalizations.of(context)!.chooseAtLeastOne;
                      });
                      return;
                    }
                    int errors = 0;

                    for (Streaming element
                        in productionController['streaming']) {
                      final int index =
                          productionController['streaming'].indexOf(element);

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
