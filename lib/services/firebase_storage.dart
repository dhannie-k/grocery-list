import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage = FirebaseStorage.instance;

  //Upload picture and get URL
  Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    StorageReference ref = storage.ref().child(fileName);
    StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  //TODO: write delete function
  Future<void> deleteImage(String imgUrl) {
    StorageReference ref = storage.ref().child(imgUrl);
    return ref.delete().catchError((error) => error.toString());
  }
}
