import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/models/user.dart';

class Review extends Equatable {
  final String? id;
  final String? userId;
  final String? productId;
  final String text;
  final int rating;
  final UserModel? user;
  final Product? product;

  const Review(
      {this.id,
      this.userId,
      this.productId,
      required this.text,
      required this.rating,
      this.user,
      this.product});

  Review copyWith({
    UserModel? user,
    String? text,
    int? rating,
    Product? product,
  }) {
    return Review(
      user: user ?? UserModel.empty,
      text: text ?? '',
      rating: rating ?? 5,
      product: product,
    );
  }

  static Review fromSnapshot(DocumentSnapshot snap) {
    Review brand = Review(
      id: snap.id,
      userId: snap['userID'],
      productId: snap['productID'],
      text: snap['text'],
      rating: snap['rating'],
    );
    return brand;
  }

  Map<String, Object> toDocument() {
    return {
      'userID': user!.id!,
      'productID': product!.id,
      'text': text,
      'rating': rating
    };
  }

  @override
  List<Object?> get props =>
      [id, productId, userId, text, rating, user, product];
}
