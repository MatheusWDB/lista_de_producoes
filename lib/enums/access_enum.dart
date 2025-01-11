import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum AccessEnum {
  absent('Selecione o acesso'),
  buyRent('Compra/Aluguel'),
  free('Grátis'),
  signature('Assinatura');

  String displayNameTranslate(BuildContext context) {
    switch (this) {
      case AccessEnum.absent:
        return AppLocalizations.of(context)!.selectAccess;
      case AccessEnum.buyRent:
        return AppLocalizations.of(context)!.buyRent;
      case AccessEnum.free:
        return AppLocalizations.of(context)!.free;
      case AccessEnum.signature:
        return AppLocalizations.of(context)!.signature;
    }
  }

  final String displayName;

  const AccessEnum(this.displayName);

  @override
  String toString() => displayName;
}
