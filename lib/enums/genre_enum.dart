enum GenreEnum {
  a('a'); 

  final String displayName;

  const GenreEnum(this.displayName);

  @override
  String toString() => displayName;
}
