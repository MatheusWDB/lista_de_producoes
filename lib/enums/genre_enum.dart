import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum GenreEnum {
  absent;

  String? displayNameTranslate(BuildContext context) {
    switch (this) {
      case GenreEnum.absent:
        return null;
    }
  }

  @override
  String toString() => name;
}
