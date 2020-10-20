import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File> getImage() async {
  File imageFile = File('');
  final picker = ImagePicker();
  final pickedFile =
      await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
  if (pickedFile != null)
    return imageFile = File(pickedFile.path);
  else
    print('no image selected');
  return imageFile;
}
