import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository {
  const FirebaseStorageRepository();

  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required dynamic image,
    required int userIdHashed,
  }) async {
    final String imageName = "$userIdHashed.jpg";
    final Reference ref =
        _firebaseStorage.ref().child("users/images/$imageName");
    final UploadTask uploadTask = ref.putFile(image as File);
    await uploadTask.whenComplete(() {});
    return uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<String> getImageURL({required String imageName}) async {
    final Reference ref =
        _firebaseStorage.ref().child("users/images/$imageName.jpg");
    return ref.getDownloadURL();
  }
}
