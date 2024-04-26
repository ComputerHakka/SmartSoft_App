import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/product.dart';

class Wishlist extends Equatable {
  final String id;
  final String userId;
  final List<Product>? products;
  final List<String>? productsIDs;

  const Wishlist({
    this.id = '',
    this.userId = '',
    this.products = const <Product>[],
    this.productsIDs = const <String>[],
  });

  static Wishlist fromSnapshot(DocumentSnapshot snap) {
    Wishlist wishlist = Wishlist(
      id: snap.id,
      userId: snap['userID'],
      productsIDs: List.from(snap['favoriteProducts']),
    );
    return wishlist;
  }

  Map<String, Object> toDocument() {
    return {
      'userID': userId,
      'favoriteProducts': [],
    };
  }

  @override
  List<Object?> get props => [id, userId, productsIDs];
}
