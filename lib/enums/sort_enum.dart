enum SortEnum {
  date('Data de criação'),
  watched('Assistidos'),
  alphabeticalOrder('Ordem alfabética'),
  category('Categoria'),
  streaming('Serviço de streaming'),
  access('Modo de acesso');

  final String displayName;

  const SortEnum(this.displayName);

  @override
  String toString() => displayName;
}
