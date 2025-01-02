enum TypeEnum {
  absent('Selecione o tipo'),
  anime('Anime'),
  cartoon('Desenho Animado'),
  documentary('Documentário'),
  filmedTheater('Teatro Filmado'),
  film('Filme'),
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

  final String displayName;

  const TypeEnum(this.displayName);

  @override
  String toString() => displayName;
}
