enum FilterEnum {
  all('Todos'),
  watched('Assistidos'),
  unwatched('Não Assistidos'),
  category('Categori:'),
  streaming('Serviço e Streaming:'),
  access('Modo de Acesso:');

  final String displayName;

  const FilterEnum(this.displayName);

  @override
  String toString() => displayName;
}
