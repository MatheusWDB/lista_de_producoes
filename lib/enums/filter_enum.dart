import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum FilterEnum {
  all,
  watched,
  unwatched,
  category,
  streaming,
  access;

  String displayNameTranslate(BuildContext context) {
    switch (this) {
      case FilterEnum.all:
        return AppLocalizations.of(context)!.all;
      case FilterEnum.watched:
        return AppLocalizations.of(context)!.watched;
      case FilterEnum.unwatched:
        return AppLocalizations.of(context)!.unwatched;
      case FilterEnum.category:
        return AppLocalizations.of(context)!.category;
      case FilterEnum.streaming:
        return AppLocalizations.of(context)!.streaming;
      case FilterEnum.access:
        return AppLocalizations.of(context)!.accessMode;
    }
  }

  @override
  String toString() => name;
}
