import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum GenreEnum {
  a('a');

  String displayNameTranslate(BuildContext context) {
    switch (this) {
      case GenreEnum.a:
        return AppLocalizations.of(context)!.selectCategory;
    }
  }

  final String displayName;

  const GenreEnum(this.displayName);

  @override
  String toString() => displayName;
}
