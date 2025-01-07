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
            return PopupMenuItem(
              value: value,
              child: Container(
                height: 20,
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: PopupMenuButton(
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  offset: const Offset(-181, -14),
                  requestFocus: true,
                  initialValue: filterByCategory,
                  itemBuilder: (context) {
                    return CategoryEnum.values.map((category) {
                      return PopupMenuItem(
                        value: category,
                        child: Text(category.displayName),
                      );
                    }).toList();
                  },
                  onSelected: (valueEnum) {
                    onSelectedByEnum(valueEnum, value);
                    Navigator.pop(context);
                  },
                  child: Text(value.displayName),
                ),
              ),
            );
          } else if (value == FilterEnum.streaming) {
            return PopupMenuItem(
              value: value,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: PopupMenuButton(
                  constraints: BoxConstraints(
                    maxWidth: double.infinity, // Largura mínima possível
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  offset: const Offset(-181, -13.9),
                  requestFocus: true,
                  initialValue: filterByStreamingService,
                  itemBuilder: (context) {
                    return StreamingEnum.values.map((streaming) {
                      return PopupMenuItem(
                        value: streaming,
                        child: Text(streaming.displayName),
                      );
                    }).toList();
                  },
                  onSelected: (valueEnum) {
                    onSelectedByEnum(valueEnum, value);
                    Navigator.pop(context);
                  },
                  child: Text(value.displayName),
                ),
              ),
            );
          } else if (value == FilterEnum.access) {
            return PopupMenuItem(
              value: value,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                child: PopupMenuButton(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity, // Largura mínima possível
                  ),
                  offset: const Offset(-181, -22),
                  requestFocus: true,
                  initialValue: filterByAccessMode,
                  itemBuilder: (context) {
                    return AccessEnum.values.map((access) {
                      return PopupMenuItem(
                        value: access,
                        child: Text(access.displayName),
                      );
                    }).toList();
                  },
                  onSelected: (valueEnum) {
                    onSelectedByEnum(valueEnum, value);
                    Navigator.pop(context);
                  },
                  child: Text(value.displayName),
                ),
              ),
            );
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
}
