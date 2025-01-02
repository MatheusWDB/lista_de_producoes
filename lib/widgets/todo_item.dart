import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_2/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(bool?) onChanged;
  final Function(Todo) onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const BehindMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {
                onDelete(todo);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(10)),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: CheckboxListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  todo.category.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            subtitle: Container(              
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Text(
                todo.streaming.map((item) {
                  return '${item.streamingService.displayName}: ${item.accessMode!.displayName}';
                }).join('\n'),
              ),
            ),
            value: todo.ok,
            secondary: CircleAvatar(
              child: Icon(
                todo.ok ? Icons.task_alt : Icons.pending_outlined,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
