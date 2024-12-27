import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final int index;
  final Function(bool?) onChanged;
  final VoidCallback onDismissed;

  const TaskItem({
    super.key,
    required this.task,
    required this.index,
    required this.onChanged,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: const Alignment(-0.9, 0.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(task['title']),
        value: task['ok'],
        secondary: CircleAvatar(
          child: Icon(
            task['ok'] ? Icons.task_alt : Icons.pending_outlined,
          ),
        ),
        onChanged: onChanged,
      ),
      onDismissed: (direction) => onDismissed(),
    );
  }
}
