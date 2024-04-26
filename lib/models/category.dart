import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String imgUrl;

  const Category({required this.id, required this.name, required this.imgUrl});

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      id: snap.id,
      name: snap['name'],
      imgUrl: snap['imgUrl'],
    );
    return category;
  }

  static List<Category> categories = [];

  @override
  List<Object?> get props => [id, name, imgUrl];
}
