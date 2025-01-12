import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

enum CategoryEnum {
  absent,
  anime,
  cartoon,
  documentary,
  filmedTheater,
  movie,
  machinima,
  miniseries,
  motionComic,
  musicVideo,
  realityShow,
  serial,
  shortFilm,
  soapOpera,
  special,
  tvSeries,
  tvShow,
  videoPodcast,
  webSeries;

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

  @override
  String toString() => name;
}
