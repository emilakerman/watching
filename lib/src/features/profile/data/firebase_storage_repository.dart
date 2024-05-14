import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage_web/firebase_storage_web.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseStorageRepository {
  const FirebaseStorageRepository();

  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // static final _firebaseStorageWeb =
  //     FirebaseStorageWeb(bucket: dotenv.env['storageBucket']!);

  Future<String> uploadImage({
    required File image,
    required int userIdHashed,
  }) async {
    final String imageName = "$userIdHashed.jpg";
    final Reference ref =
        _firebaseStorage.ref().child("users/images/$imageName");
    final UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() {});
    return uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<String> getImageURL({required String imageName}) async {
    final Reference ref =
        _firebaseStorage.ref().child("users/images/$imageName.jpg");
    return ref.getDownloadURL();
  }
}
