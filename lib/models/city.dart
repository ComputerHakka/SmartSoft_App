import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;

  const City({
    required this.id,
    required this.name,
  });

  static City fromSnapshot(DocumentSnapshot snap) {
    City city = City(
      id: snap.id,
      name: snap['name'],
    );
    return city;
  }

  @override
  List<Object?> get props => [id, name];
}
