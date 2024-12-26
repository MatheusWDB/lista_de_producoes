import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.todo,
    required this.onDelete,
  });

  final String todo;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const BehindMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {
                onDelete(todo);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: const Color(0xFFFFFFFF),
              icon: Icons.delete,
              label: 'Delete',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(10)),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now()),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
