import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:list_of_productions/enums/access_enum.dart';
import 'package:list_of_productions/enums/category_enum.dart';
import 'package:list_of_productions/enums/filter_enum.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';

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
      itemBuilder: (context) {
        return FilterEnum.values.map((value) {
          if (value == FilterEnum.category) {
            return subMenu(
                value,
                context,
                MediaQuery.of(context).size.width * (-0.41),
                CategoryEnum.values,
                filterByCategory);
          } else if (value == FilterEnum.streaming) {
            return subMenu(
                value,
                context,
                MediaQuery.of(context).size.width * (-0.41),
                StreamingEnum.values,
                filterByStreamingService);
          } else if (value == FilterEnum.access) {
            return subMenu(
                value,
                context,
                MediaQuery.of(context).size.width * (-0.41),
                AccessEnum.values,
                filterByAccessMode);
          } else {
            return PopupMenuItem(
              value: value,
              child: Text(switch (value) {
                FilterEnum.all => AppLocalizations.of(context)!.all,
                FilterEnum.watched => AppLocalizations.of(context)!.watched,
                FilterEnum.unwatched => AppLocalizations.of(context)!.unwatched,
                FilterEnum.category => AppLocalizations.of(context)!.category,
                FilterEnum.streaming => AppLocalizations.of(context)!.streaming,
                FilterEnum.access => AppLocalizations.of(context)!.accessMode,
              }),
            );
          }
        }).toList();
      },
      child: TextButton.icon(
        onPressed: null,
        label: Text(
          '${AppLocalizations.of(context)!.filterBy} ${filter.displayNameTranslate(context)}',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        iconAlignment: IconAlignment.end,
      ),
    );
  }

  PopupMenuItem subMenu(FilterEnum value, BuildContext context, double offsetX,
      List<dynamic> enumValues, Enum initialValue) {
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      value: value,
      child: PopupMenuButton(
        shadowColor: Colors.blueAccent,
        elevation: 5,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.35,
          minWidth: MediaQuery.of(context).size.width * 0.408,
        ),
        offset: Offset(offsetX, 0),
        requestFocus: true,
        initialValue: initialValue,
        itemBuilder: (context) {
          return enumValues.where((e) => e != enumValues.first).map((e) {
            return PopupMenuItem<Enum>(
              value: e,
              child: Text(e.displayNameTranslate(context)),
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
            value.displayNameTranslate(context),
          ),
        ),
      ),
    );
  }
}
