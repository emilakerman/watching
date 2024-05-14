import "dart:io" if (dart.library.html) "dart:html";
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageWebRepo {
  const FirebaseStorageWebRepo();

  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required dynamic image,
    required int userIdHashed,
  }) async {
    final String imageName = "$userIdHashed.jpg";
    final ref = _firebaseStorage.ref("users/images/").child("$imageName");
    final uploadTask = ref.putBlob(image);
    await uploadTask.whenComplete(() {});
    return uploadTask.snapshot.ref.getDownloadURL();
  }
}
