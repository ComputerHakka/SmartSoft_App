import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  final String id;
  final String addressId;

  const Shop({
    required this.id,
    required this.addressId,
  });

  static Shop fromSnapshot(DocumentSnapshot snap) {
    Shop shop = Shop(
      id: snap.id,
      addressId: snap['addressID'],
    );
    return shop;
  }

  @override
  List<Object?> get props => [id, addressId];
}
