class Ouvriername {
  // ignore: non_constant_identifier_names
  String name;
  String? lieu;
  String id;
  // ignore: non_constant_identifier_names
  Ouvriername({required this.name, required this.id, required this.lieu});
}

class Ouvriername2 {
  final String name;
  final String id;
  final double salaire;

  Ouvriername2({required this.name, required this.id, this.salaire=.0});
}
