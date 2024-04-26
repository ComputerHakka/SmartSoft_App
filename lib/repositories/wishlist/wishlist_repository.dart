import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/models/wishlist.dart';

import 'base_wishlist_repository.dart';

class WishlistRepository extends BaseWishlistRepository {
  final FirebaseFirestore _firebaseFirestore;

  WishlistRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addProductToWishlist(String productId, Wishlist wishlist) async {
    var currentDoc =
        _firebaseFirestore.collection('wishlists').doc(wishlist.id);
    currentDoc.update({
      'favoriteProducts': FieldValue.arrayUnion([productId])
    });
  }

  @override
  Future<void> createWishlist(Wishlist wishlist) async {}

  @override
  Stream<List<Wishlist>> getAllWishlists() {
    return _firebaseFirestore
        .collection('wishlists')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Wishlist.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> removeProductFromWishlist(
      String productId, Wishlist wishlist) async {
    var currentDoc =
        _firebaseFirestore.collection('wishlists').doc(wishlist.id);
    currentDoc.update({
      'favoriteProducts': FieldValue.arrayRemove([productId])
    });
  }

  @override
  Stream<Wishlist> getWishlistById(String wishlistId) {
    return _firebaseFirestore
        .collection('wishlists')
        .doc(wishlistId)
        .snapshots()
        .map((snap) => Wishlist.fromSnapshot(snap));
  }
}
