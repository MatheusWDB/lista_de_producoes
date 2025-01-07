enum FilterEnum {
  all('Tudo'),
  watched('Assistidos'),
  unwatched('Não Assistidos'),
  category('Categoria'),
  streaming('Streaming'),
  access('Modo de Acesso');

  final String displayName;

  const FilterEnum(this.displayName);

  @override
  String toString() => displayName;
}
