import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

import '../models/grocery.dart';
import '../services/firebase_auth.dart';
import '../services/firestore_repository.dart';
import '../services/firebase_storage.dart';

//Firebase Auth instance and User's auth changes
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
    (ref) => FirebaseAuthService(FirebaseAuth.instance));
final firebaseUserProvider = StreamProvider<User>(
    (ref) => ref.read(firebaseAuthServiceProvider).authStateChange);

//Firestore Groceries Collection Provider
final groceriesRepoProvider = Provider<FirestoreRepository>(
    (ref) => FirestoreRepository(collectionId: 'groceries'));
final groceryListStream = StreamProvider<List<Grocery>>(
    (ref) => ref.read(groceriesRepoProvider).getGrocery());

//Firestore Favorite/Regularly Bought Items Collection Provider
final favoriteItemsRepoProvider = Provider<FirestoreRepository>(
    (ref) => FirestoreRepository(collectionId: 'favoriteItems'));
final favoriteItemsStream = StreamProvider<List<Grocery>>(
    (ref) => ref.read(favoriteItemsRepoProvider).getGrocery());

//Firestore provider
final firebaseStorageProvider =
    Provider<StorageService>((ref) => StorageService());
