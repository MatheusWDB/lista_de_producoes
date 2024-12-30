import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_2/models/todo.dart';

class TaskItem extends StatelessWidget {
  final Todo task;
  final Function(bool?) onChanged;
  final Function(Todo) onDelete;

  const TaskItem({
    super.key,
    required this.task,
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
                onDelete(task);
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
        child: CheckboxListTile(
          title: Text(
            task.title,
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            task.description,
            style: const TextStyle(fontSize: 12),
          ),
          value: task.ok,
          secondary: CircleAvatar(
            child: Icon(
              task.ok ? Icons.task_alt : Icons.pending_outlined,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
