import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DeleteProductionsConfirmationDialog extends StatelessWidget {
  const DeleteProductionsConfirmationDialog({
    super.key,
    required this.context,
    required this.deleteAllProductions,
    required this.myLocale,
  });

  final BuildContext context;
  final VoidCallback deleteAllProductions;
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
            deleteAllProductions();
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
