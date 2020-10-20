import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/grocery.dart';

class FirestoreRepository {
  FirestoreRepository({this.collectionId});
  final String collectionId;
  final _firestoreRepo = FirebaseFirestore.instance;

  //GET data
  Stream<List<Grocery>> getGrocery() {
    return _firestoreRepo.collection(collectionId).snapshots().map((snapshot) {
      return snapshot.docs.map((item) => Grocery.fromSnapshot(item)).toList();
    });
  }

  //ADD data
  Future<void> addItem(Grocery item) {
    return _firestoreRepo.collection(collectionId).add(item.toMap());
  }

  //EDIT/UPDATE data
  Future<void> updateItem(String itemId, Grocery newData) {
    return _firestoreRepo
        .collection(collectionId)
        .doc(itemId)
        .update(newData.toMap());
  }

  //DELETE data
  Future<void> deleteItem(String itemId) {
    return _firestoreRepo.collection(collectionId).doc(itemId).delete();
  }

  Future<void> batchDelete() {
    CollectionReference collectionRef = _firestoreRepo.collection(collectionId);
    WriteBatch batch = _firestoreRepo.batch();
    return collectionRef.get().then((querySnaphsot) {
      querySnaphsot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
      return batch.commit();
    });
  }
}
