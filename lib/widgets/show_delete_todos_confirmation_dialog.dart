import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ShowDeleteTodosConfirmationDialog extends StatelessWidget {
  const ShowDeleteTodosConfirmationDialog({
    super.key,
    required this.context,
    required this.deleteAllTodos,
    required this.myLocale,
  });

  final BuildContext context;
  final Function deleteAllTodos;
  final Locale myLocale;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.clearAllConfirmationDialog,
      ),
      content: Text(
        AppLocalizations.of(context)!.confirmDeleteAll,
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            deleteAllTodos();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: Text(
            AppLocalizations.of(context)!.clearAll,
          ),
        ),
      ],
    );
  }
}
