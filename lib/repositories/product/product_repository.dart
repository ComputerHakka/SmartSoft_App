import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartsoft_application/models/product.dart';
import 'base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<Product> getProductById(String productId) {
    return _firebaseFirestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((snap) => Product.fromSnapshot(snap));
  }
}
