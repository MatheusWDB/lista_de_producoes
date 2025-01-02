import 'package:flutter/material.dart';

class ShowDeleteTodosConfirmationDialog extends StatelessWidget {
  const ShowDeleteTodosConfirmationDialog({
    super.key,
    required this.context,
    required this.deleteAllTodos,
  });

  final BuildContext context;
  final Function deleteAllTodos;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Limpar Tudo?',
      ),
      content: Text(
        'Tem certeza que deseja pagar todas os títulos?',
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
          child: Text('Cancelar'),
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
            'Limpar Tudo',
          ),
        ),
      ],
    );
  }
}
