import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String brandId;
  final String? description;
  final int price;
  final Map<String, dynamic>? characteristics;
  final String imgUrl;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.brandId,
    this.description,
    required this.price,
    required this.imgUrl,
    this.characteristics,
  });

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      id: snap.id,
      name: snap['name'],
      categoryId: snap['categoryID'],
      brandId: snap['brandID'],
      price: snap['price'],
      description: snap['description'],
      imgUrl: snap['imgUrl'],
      characteristics: snap['characteristics'],
    );
    return product;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        categoryId,
        brandId,
        description,
        price,
        imgUrl,
        characteristics
      ];
}
