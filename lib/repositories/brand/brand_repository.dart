import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/brand.dart';
import 'base_brand_repository.dart';

class BrandRepository extends BaseBrandRepository {
  final FirebaseFirestore _firebaseFirestore;

  BrandRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Brand>> getAllBrands() {
    return _firebaseFirestore.collection('brands').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Brand.fromSnapshot(doc)).toList();
    });
  }
}
