import 'package:flutter/material.dart';
import 'package:todo_list_2/enums/sort_enum.dart';

class PopupMenuSorting extends StatelessWidget {
  const PopupMenuSorting({
    super.key,
    required this.sort,
    required this.ascending,
    required this.onSelected,
  });

  final SortEnum sort;
  final bool ascending;
  final Function(Object?) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      requestFocus: true,
      offset: const Offset(0, 45),
      initialValue: sort,
      onSelected: onSelected,
      itemBuilder: (context) {
        return SortEnum.values.map((sort) {
          return PopupMenuItem<SortEnum>(
            value: sort,
            child: Text(sort.displayName),
          );
        }).toList();
      },
      child: TextButton.icon(
        onPressed: null,
        label: Text(
          sort.displayName,
          style: const TextStyle(color: Colors.black),
        ),
        icon: Icon(
          ascending == true ? Icons.arrow_upward : Icons.arrow_downward,
          color: Colors.black,
        ),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
