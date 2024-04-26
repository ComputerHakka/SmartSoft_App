import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/address.dart';
import 'base_address_repository.dart';

class AddressRepository extends BaseAddressRepository {
  final FirebaseFirestore _firebaseFirestore;

  AddressRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Address>> getAllAddresses() {
    return _firebaseFirestore
        .collection('addresses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Address.fromSnapshot(doc)).toList();
    });
  }
}
