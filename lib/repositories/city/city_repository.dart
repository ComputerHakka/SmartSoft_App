import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/city.dart';
import 'base_city_repository.dart';

class CityRepository extends BaseCityRepository {
  final FirebaseFirestore _firebaseFirestore;

  CityRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<City>> getAllCities() {
    return _firebaseFirestore.collection('cities').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => City.fromSnapshot(doc)).toList();
    });
  }
}
