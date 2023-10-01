import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // adding profile photo to the storage
  Future<String> uploadProfilePhoto(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      final String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String getDownloadURL = await snap.ref.getDownloadURL();
    return getDownloadURL;
  }

  Future<bool> deleteExistingProfilePhoto() async {
    try {
      Reference ref =
          _storage.ref().child('profilePics').child(_auth.currentUser!.uid);
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
