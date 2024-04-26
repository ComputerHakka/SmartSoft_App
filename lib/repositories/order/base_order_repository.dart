import 'package:smartsoft_application/models/order.dart';
import 'package:smartsoft_application/models/user.dart';

abstract class BaseOrderRepository {
  Future<void> addOrder(OrderModel order);
  Stream<List<OrderModel>> getAllOrders();
}
