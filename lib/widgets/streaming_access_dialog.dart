import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:watchlist_plus/enums/access_enum.dart';
import 'package:watchlist_plus/enums/streaming_enum.dart';
import 'package:watchlist_plus/models/streaming.dart';

class StreamingAccessDialog extends StatefulWidget {
  const StreamingAccessDialog({
    super.key,
    required this.error,
    required this.productionController,
    required this.back,
  });

  final Map<String, dynamic> error;
  final List<Streaming> productionController;
  final Function(BuildContext) back;

  @override
  State<StreamingAccessDialog> createState() => _StreamingAccessDialogState();
}

class _StreamingAccessDialogState extends State<StreamingAccessDialog> {
  @override
  void initState() {
    super.initState();
    productionControllerOriginal = [...widget.productionController];
    error = widget.error;
    productionController = widget.productionController;
    back = widget.back;
  }

  late List<Streaming> productionControllerOriginal;
  late Map<String, dynamic> error;
  late List<Streaming> productionController;
  late Function(BuildContext) back;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.selectStreamingAndAccess),
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
                      .where((streaming) => streaming != StreamingEnum.absent)
                      .map((streaming) {
                    final bool isSelected = productionController
                        .any((entry) => entry.streamingService == streaming);
                    final int index = productionController.indexWhere(
                        (entry) => entry.streamingService == streaming);
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
                                title: Text(
                                    streaming.displayNameTranslate(context)),
                                value: isSelected,
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected == true) {
                                      productionController.add(Streaming(
                                          streamingService: streaming,
                                          accessMode: AccessEnum.absent));
                                      error['streamingService'] = null;
                                    } else {
                                      productionController.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: DropdownMenu<AccessEnum>(
                                    errorText: error['accessMode'][index],
                                    initialSelection:
                                        productionController[index].accessMode,
                                    dropdownMenuEntries:
                                        AccessEnum.values.map((access) {
                                      return DropdownMenuEntry(
                                        value: access,
                                        label: access
                                            .displayNameTranslate(context),
                                      );
                                    }).toList(),
                                    onSelected: (newValue) {
                                      setState(() {
                                        productionController[index] = Streaming(
                                          streamingService: streaming,
                                          accessMode: newValue!,
                                        );
                                        error['accessMode'][index] = null;
                                      });
                                    },
                                  ),
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
            // VERIFICAR QUAIS ELEMENTOS DE productionController SÃO IGUAIS AOS ELEMENTOS DE productionControllerOriginal
            // productionController = [...productionControllerOriginal];
            back(context);
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
            if (productionController.isEmpty) {
              setState(() {
                error['streamingService'] =
                    AppLocalizations.of(context)!.chooseAtLeastOne;
              });
              return;
            }
            int errors = 0;

            for (Streaming element in productionController) {
              final int index = productionController.indexOf(element);

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
  }

  void resetError() {}
}
