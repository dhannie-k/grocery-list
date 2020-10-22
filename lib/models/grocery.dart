import 'package:cloud_firestore/cloud_firestore.dart';

class Grocery {
  String id;
  String name;
  int quantity;
  String unit; //bottle, pack, pc, box
  double price;
  String imageUrl;
  bool purchased;
  DocumentReference reference;
  Grocery(
      {this.name,
      this.quantity,
      this.unit,
      this.price,
      this.imageUrl,
      this.purchased = false})
      : id = null,
        reference = null;

  Grocery copyWith(
      {String name,
      int quantity,
      String unit,
      double price,
      String imageUrl,
      bool purchased}) {
    return Grocery(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      purchased: purchased ?? this.purchased,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'imageUrl': imageUrl,
      'purchased': purchased,
    };
  }

  Grocery.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        reference = snapshot.reference,
        name = snapshot.data()['name'],
        quantity = snapshot.data()['quantity'],
        unit = snapshot.data()['unit'],
        price = (snapshot.data()['price'] as num)?.toDouble(),
        imageUrl = snapshot.data()['imageUrl'],
        purchased = snapshot.data()['purchased'];
}
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======


>>>>>>> de7038ea30dab370c28f1fb9cdd790ac3e6a8173
>>>>>>> fcd0ccae36d399beb5e185a50c319894aaa63da2
