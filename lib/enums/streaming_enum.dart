enum StreamingEnum {
  absent('Selecione o streaming'),
  apple('Apple TV+'),
  crunchy('Crunchyroll'),
  disney('Disney+'),
  globo('Globoplay'),
  max('Max'),
  netflix('Netflix'),
  paramount('Paramount+'),
  pluto('Pluto TV'),
  prime('Prime Video'),
  sbt('SBT+'),
  telecine('Telecine'),
  youtube('YouTube'),
  piracy('Outro');

  final String displayName;

  const StreamingEnum(this.displayName);

  @override
  String toString() => displayName;
}
