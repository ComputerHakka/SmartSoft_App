import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Brand extends Equatable {
  final String id;
  final String name;
  final String? imgUrl;

  const Brand({required this.id, required this.name, this.imgUrl});

  static Brand fromSnapshot(DocumentSnapshot snap) {
    Brand brand = Brand(
      id: snap.id,
      name: snap['name'],
      imgUrl: snap['imgUrl'],
    );
    return brand;
  }

  @override
  List<Object?> get props => [id, name, imgUrl];
}
