import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String? imgUrl;
  final String email;
  final int level;

  const UserModel({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.level = 1,
    this.imgUrl = '',
  });

  UserModel copyWith(
      {String? id,
      String? firstName,
      String? lastName,
      int? level,
      String? imgUrl,
      String? email}) {
    return UserModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        level: level ?? this.level,
        imgUrl: imgUrl ?? this.imgUrl,
        email: email ?? this.email);
  }

  static UserModel fromSnapshot(DocumentSnapshot snap) {
    UserModel user = UserModel(
        id: snap.id,
        firstName: snap['firstName'],
        lastName: snap['lastName'],
        email: snap['email'],
        level: snap['level'],
        imgUrl: snap['imgUrl']);
    return user;
  }

  Map<String, Object> toDocument() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'level': level,
      'imgUrl': imgUrl!,
    };
  }

  static const empty = UserModel(id: '');

  @override
  List<Object?> get props => [id, firstName, lastName, level, imgUrl, email];
}
