import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/models/wishlist.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  UserRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<void> createUser(UserModel user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(user.toDocument());
    await _firebaseFirestore
        .collection('wishlists')
        .add(Wishlist(userId: user.id!).toDocument());
  }

  @override
  Stream<UserModel> getUser(String userId) {
    print('Getting data from Firestore');
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => UserModel.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser(UserModel user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toDocument())
        .then((value) => print('User document updated'));
  }

  @override
  Future<void> changePhoto(UserModel user, File photo) async {
    if (user.imgUrl != null && user.imgUrl!.isNotEmpty) {
      final existingReference = _firebaseStorage.refFromURL(user.imgUrl!);
      await existingReference.delete();
    }

    final Reference storageReference = _firebaseStorage
        .ref()
        .child('user_photos')
        .child('${user.email}_photo.jpg');

    final uploadTask = storageReference.putFile(photo);

    final snapshot = await uploadTask.whenComplete(() {});
    final photoUrl = await snapshot.ref.getDownloadURL();

    _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update({'imgUrl': photoUrl});
  }
}
