enum AccessEnum {
  absent('Selecione o acesso'),
  buyRent('Compra/Aluguel'),
  free('Grátis'),
  signature('Assinatura');

  final String displayName;

  const AccessEnum(this.displayName);

  @override
  String toString() => displayName;
}
