import 'package:smartsoft_application/models/product.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  Stream<Product> getProductById(String productId);
}
