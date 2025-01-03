import 'package:flutter/material.dart';

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
        myLocale.languageCode == 'pt' ? 'Limpar Tudo?' : 'Clear All?',
      ),
      content: Text(
        myLocale.languageCode == 'pt'
            ? 'Tem certeza que deseja pagar todas os títulos?'
            : 'Are you sure you want to pay all the bills?',
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
          child: Text(myLocale.languageCode == 'pt' ? 'Cancelar' : 'Cancel'),
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
            myLocale.languageCode == 'pt' ? 'Limpar Tudo' : 'Clear All',
          ),
        ),
      ],
    );
  }
}
