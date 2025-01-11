import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';
import 'package:list_of_productions/models/production.dart';
import 'package:list_of_productions/widgets/update_production.dart';

class ProductionItem extends StatelessWidget {
  final Production production;
  final List<Production> productionList;
  final Function(bool?) onChanged;
  final Function(Production) onDelete;
  final VoidCallback readListOfProductions;

  const ProductionItem({
    super.key,
    required this.production,
    required this.productionList,
    required this.onChanged,
    required this.onDelete,
    required this.readListOfProductions,
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
              onDelete(productionList
                  .firstWhere((element) => element == production));
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
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const BehindMotion(),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              showDialog(
                  context: context,
                  builder: (context) => UpdateList(
                        production: production,
                        productionList: productionList,
                        readListOfProductions: readListOfProductions,
                      ));
            },
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
            icon: Icons.mode_edit_outline_outlined,
            label: AppLocalizations.of(context)!.edit,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(10)),
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
                production.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                production.category.displayNameTranslate(context),
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
                children: production.streaming.map((item) {
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
                    _ => const Color(0xFF000000),
                  };
                  return TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${item.streamingService.displayNameTranslate(context)}: ',
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
                            '${item.accessMode!.displayNameTranslate(context)}${item != production.streaming.last ? '\n' : ''}',
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
          value: production.watched,
          secondary: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(
              production.watched ? Icons.tv_outlined : Icons.tv_off_outlined,
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
