import 'package:cloud_firestore/cloud_firestore.dart';

class Engrai {
  final String name;
  final String url;
  final String id;
  final double priv;
  final double pria;
  final double tva;
  final double remise;
  final int quantity;
  Engrai(
      {required this.quantity,
      required this.priv,
      required this.pria,
      required this.name,
      required this.url,
      required this.id,
      required this.tva,
      required this.remise});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": url,
      "priv": priv,
      "pria": pria,
      "quantity": quantity,
      "remise": remise,
      "tva": tva
    };
  }

  static Engrai fromMap(DocumentSnapshot e) {
    return Engrai(
      priv: e["priv"] as double,
      pria: e["pria"] as double,
      name: e["name"],
      url: e["image"],
      quantity: e["quantity"] as int,
      tva: e["tva"] as double,
      remise: e["remise"] as double,
      id: e.id,
    );
  }

  static Engrai fromMap2(Map<String, dynamic> e) {
    return Engrai(
      priv: e["priv"] as double,
      pria: e["pria"] as double,
      name: e["name"],
      url: e["image"],
      quantity: e["quantity"] as int,
      tva: e["tva"] as double,
      remise: e["remise"] as double,
      id: "2",
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
