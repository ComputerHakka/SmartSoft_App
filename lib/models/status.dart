import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Status extends Equatable {
  final String id;
  final String name;

  const Status({required this.id, required this.name});

  static Status fromSnapshot(DocumentSnapshot snap) {
    Status status = Status(
      id: snap.id,
      name: snap['name'],
    );
    return status;
  }

  @override
  List<Object?> get props => [id, name];
}
