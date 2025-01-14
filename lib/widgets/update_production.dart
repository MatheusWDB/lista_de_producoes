import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:watchlist_plus/enums/access_enum.dart';
import 'package:watchlist_plus/enums/category_enum.dart';
import 'package:watchlist_plus/models/production.dart';
import 'package:watchlist_plus/models/streaming.dart';
import 'package:watchlist_plus/widgets/streaming_access_dialog.dart';

class UpdateList extends StatefulWidget {
  const UpdateList({
    super.key,
    required this.production,
    required this.updateProduction,
  });

  final Production production;
  final Function(Map<String, dynamic>, Production, BuildContext)
      updateProduction;

  @override
  State<UpdateList> createState() => _UpdateListState();
}

class _UpdateListState extends State<UpdateList> {
  late Production production;
  late List<Streaming> streamingOriginal;
  late Function(Map<String, dynamic>, Production, BuildContext)
      updateProduction;

  late final Map<String, dynamic> productionController = {
    'title': TextEditingController(text: production.title),
    'category': production.category,
    'streaming': [...production.streaming]
  };

  final Map<String, dynamic> error = {
    'title': null,
    'category': null,
    'streamingService': null,
    'accessMode': [],
  };

  @override
  void initState() {
    super.initState();
    production = widget.production;
    streamingOriginal = [...widget.production.streaming];
    updateProduction = widget.updateProduction;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editTitle),
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
                            color: Colors.red,
                          ),
                  ),
                  onPressed: () {
                    setState(() {
                      error['streamingService'] = null;
                    });
                    showDialog(
                      context: context,
                      builder: (context) => StreamingAccessDialog(
                        error: error,
                        productionController: productionController['streaming'],
                        back: back,
                        confirm: confirm,
                      ),
                    );
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
            updateProduction(productionController, production, context);

            resetProductionController();
            resetError();
          },
          child: Text(
            AppLocalizations.of(context)!.save,
            style: const TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  void resetProductionController() {
    productionController['title'] =
        TextEditingController(text: production.title);
    productionController['category'] = production.category;
    productionController['streaming'] = [...production.streaming];
  }

  void resetError() {
    error['title'] = null;
    error['category'] = null;
    error['streamingService'] = null;
    error['accessMode'].clear();
  }

  void back(BuildContext context) {
    Navigator.pop(context);
    productionController['streaming'] = [...streamingOriginal];
    resetError();
  }

  void confirm(BuildContext context) {
    Navigator.pop(context);
    streamingOriginal = [...productionController['streaming']];
  }
}
