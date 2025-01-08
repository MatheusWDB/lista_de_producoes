import 'package:flutter/material.dart';
import 'package:todo_list_2/enums/access_enum.dart';
import 'package:todo_list_2/enums/category_enum.dart';
import 'package:todo_list_2/enums/filter_enum.dart';
import 'package:todo_list_2/enums/streaming_enum.dart';

class PopupMenuFiltering extends StatelessWidget {
  final FilterEnum filter;

  final Function(Object?) onSelected;
  final CategoryEnum filterByCategory;
  final StreamingEnum filterByStreamingService;
  final AccessEnum filterByAccessMode;
  final Function(Enum, FilterEnum) onSelectedByEnum;

  const PopupMenuFiltering({
    super.key,
    required this.filter,
    required this.onSelected,
    required this.filterByCategory,
    required this.filterByStreamingService,
    required this.filterByAccessMode,
    required this.onSelectedByEnum,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shadowColor: Colors.blueAccent,
      elevation: 5,
      requestFocus: true,
      offset: const Offset(0, 45),
      initialValue: filter,
      onSelected: onSelected,
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // Largura mínima possível
      ),
      itemBuilder: (context) {
        return FilterEnum.values.map((value) {
          if (value == FilterEnum.category) {
            return subMenu(
                value, context, 0, CategoryEnum.values, filterByCategory);
          } else if (value == FilterEnum.streaming) {
            return subMenu(value, context, 0, StreamingEnum.values,
                filterByStreamingService);
          } else if (value == FilterEnum.access) {
            return subMenu(
                value, context, -8, AccessEnum.values, filterByAccessMode);
          } else {
            return PopupMenuItem(
              value: value,
              child: Container(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  child: Text(value.displayName)),
            );
          }
        }).toList();
      },
      child: TextButton.icon(
        onPressed: null,
        label: Text(
          'Filtrar por: ${filter.displayName}',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        iconAlignment: IconAlignment.end,
      ),
    );
  }

  PopupMenuItem subMenu(FilterEnum value, BuildContext context, double offsetY,
      List<dynamic> enumValues, Enum initialValue) {
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      value: value,
      child: PopupMenuButton(
        shadowColor: Colors.blueAccent,
        elevation: 5,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        offset: Offset(-168, offsetY),
        requestFocus: true,
        initialValue: initialValue,
        itemBuilder: (context) {
          return enumValues.map((e) {
            return PopupMenuItem<Enum>(
              value: e,
              child: Text(e.displayName),
            );
          }).toList();
        },
        onSelected: (valueEnum) {
          onSelectedByEnum(valueEnum, value);
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 48,
          child: Text(
            value.displayName,
          ),
        ),
      ),
    );
  }
}
