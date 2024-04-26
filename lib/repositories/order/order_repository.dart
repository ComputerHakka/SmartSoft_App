import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartsoft_application/models/order.dart';
import 'package:smartsoft_application/models/user.dart';

import 'base_order_repository.dart';

class OrderRepository extends BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addOrder(OrderModel order) {
    return _firebaseFirestore.collection('orders').add(order.toDocument());
  }

  @override
  Stream<List<OrderModel>> getAllOrders() {
    return _firebaseFirestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }
}
