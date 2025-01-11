import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum CategoryEnum {
  absent('Selecione a categoria'),
  anime('Anime'),
  cartoon('Desenho Animado'),
  documentary('Documentário'),
  filmedTheater('Teatro Filmado'),
  movie('Filme'),
  machinima('Machinima'),
  miniseries('Minissérie'),
  motionComic('Quadrinho Animado'),
  musicVideo('Videoclipe'),
  realityShow('Reality Show'),
  serial('Seriado'),
  shortFilm('Curta-metragem'),
  soapOpera('Novela'),
  special('Especial'),
  tvSeries('Série de TV'),
  tvShow('Programa de TV'),
  videoPodcast('Videocasts'),
  webSeries('Websérie');

  String displayNameTranslate(BuildContext context) {
    switch (this) {
      case CategoryEnum.absent:
        return AppLocalizations.of(context)!.selectCategory;
      case CategoryEnum.anime:
        return AppLocalizations.of(context)!.anime;
      case CategoryEnum.cartoon:
        return AppLocalizations.of(context)!.cartoon;
      case CategoryEnum.documentary:
        return AppLocalizations.of(context)!.documentary;
      case CategoryEnum.filmedTheater:
        return AppLocalizations.of(context)!.filmedTheater;
      case CategoryEnum.movie:
        return AppLocalizations.of(context)!.movie;
      case CategoryEnum.machinima:
        return AppLocalizations.of(context)!.machinima;
      case CategoryEnum.miniseries:
        return AppLocalizations.of(context)!.miniseries;
      case CategoryEnum.motionComic:
        return AppLocalizations.of(context)!.animatedComic;
      case CategoryEnum.musicVideo:
        return AppLocalizations.of(context)!.musicVideo;
      case CategoryEnum.realityShow:
        return AppLocalizations.of(context)!.realityShow;
      case CategoryEnum.serial:
        return AppLocalizations.of(context)!.serial;
      case CategoryEnum.shortFilm:
        return AppLocalizations.of(context)!.shortFilm;
      case CategoryEnum.soapOpera:
        return AppLocalizations.of(context)!.soapOpera;
      case CategoryEnum.special:
        return AppLocalizations.of(context)!.special;
      case CategoryEnum.tvSeries:
        return AppLocalizations.of(context)!.tvSeries;
      case CategoryEnum.tvShow:
        return AppLocalizations.of(context)!.tvProgram;
      case CategoryEnum.videoPodcast:
        return AppLocalizations.of(context)!.videocasts;
      case CategoryEnum.webSeries:
        return AppLocalizations.of(context)!.webSeries;
    }
  }

  final String displayName;

  const CategoryEnum(this.displayName);

  @override
  String toString() => displayName;
}
