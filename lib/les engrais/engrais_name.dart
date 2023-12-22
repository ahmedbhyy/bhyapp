import 'package:cloud_firestore/cloud_firestore.dart';

class Engrai {
  final String name;
  final String url;
  final String id;
  final double priv;
  final double pria;
  final int quantity;
  Engrai({required this.quantity, required this.priv, required this.pria, required this.name,required this.url, required this.id});

  Map<String, dynamic> toMap() {
    return {
        "name": name,
        "image": url,
        "priv": priv,
        "pria": pria,
        "quantity": quantity,
    };
  }

  static Engrai fromMap(DocumentSnapshot e) {
    return Engrai(
      priv: e["priv"] as double, 
      pria: e["pria"] as double, 
      name: e["name"], 
      url: e["image"], 
      quantity: e["quantity"] as int,
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
      id: "2",
    );
  }


  @override
  String toString() {
    return toMap().toString();
  }


}
