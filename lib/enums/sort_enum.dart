import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum SortEnum {
  creationDate('Data de criação'),
  watched('Assistidos'),
  alphabeticalOrder('Ordem alfabética'),
  category('Categoria'),
  streaming('Streaming'),
  access('Modo de acesso');

  String displayNameTranslate(BuildContext context) {
    switch (this) {
      case SortEnum.creationDate:
        return AppLocalizations.of(context)!.creationDate;
      case SortEnum.watched:
        return AppLocalizations.of(context)!.watched;
      case SortEnum.alphabeticalOrder:
        return AppLocalizations.of(context)!.alphabeticalOrder;
      case SortEnum.category:
        return AppLocalizations.of(context)!.category;
      case SortEnum.streaming:
        return AppLocalizations.of(context)!.streaming;
      case SortEnum.access:
        return AppLocalizations.of(context)!.accessMode;
    }
  }

  final String displayName;

  const SortEnum(this.displayName);

  @override
  String toString() => displayName;
}
