import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/status.dart';
import 'base_status_repository.dart';

class StatusRepository extends BaseStatusRepository {
  final FirebaseFirestore _firebaseFirestore;

  StatusRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Status>> getAllStatuses() {
    return _firebaseFirestore
        .collection('statuses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Status.fromSnapshot(doc)).toList();
    });
  }
}
