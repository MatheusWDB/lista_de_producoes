import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';
import 'package:todo_list_2/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final List<Todo> toDoList;
  final Function(bool?) onChanged;
  final Function(Todo) onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.toDoList,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const BehindMotion(),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              onDelete(toDoList.firstWhere((element) => element == todo));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(10)),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.blueAccent,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: CheckboxListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 20,
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: RichText(
              text: TextSpan(
                children: todo.streaming.map((item) {
                  final streamingColors = switch (item.streamingService) {
                    StreamingEnum.apple => const Color(0xFF999999),
                    StreamingEnum.crunchy => const Color(0xFFff640a),
                    StreamingEnum.disney => const Color(0xFF0CA8B8),
                    StreamingEnum.globo => const Color(0xFFEE3E2F),
                    StreamingEnum.max => const Color(0xFF0715A7),
                    StreamingEnum.netflix => const Color(0xFFE90916),
                    StreamingEnum.paramount => const Color(0xFF0163FF),
                    StreamingEnum.pluto => const Color(0xFFFEF21B),
                    StreamingEnum.prime => const Color(0xFF0578FF),
                    StreamingEnum.sbt => const Color(0xFF00A859),
                    StreamingEnum.telecine => const Color(0xFF010066),
                    StreamingEnum.youtube => const Color(0xFFFE0033),
                    StreamingEnum.piracy => const Color(0xFF000000),
                  };
                  return TextSpan(
                    children: [
                      TextSpan(
                        text: '${item.streamingService.displayName}: ',
                        style: TextStyle(
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: streamingColors,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text:
                            '${item.accessMode!.displayName}${item != todo.streaming.last ? '\n' : ''}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          value: todo.watched,
          secondary: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(
              todo.watched ? Icons.tv_outlined : Icons.tv_off_outlined,
              color: Colors.white,
            ),
          ),
          activeColor: Colors.blueAccent,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
