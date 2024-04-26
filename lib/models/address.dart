import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Address extends Equatable {
  final String id;
  final String cityId;
  final String home;
  final String street;

  const Address({
    required this.id,
    required this.cityId,
    required this.home,
    required this.street,
  });

  static Address fromSnapshot(DocumentSnapshot snap) {
    Address address = Address(
        id: snap.id,
        cityId: snap['cityID'],
        home: snap['home'],
        street: snap['street']);
    return address;
  }

  @override
  List<Object?> get props => [id, cityId, home, street];
}
