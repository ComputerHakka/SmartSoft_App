import 'package:equatable/equatable.dart';

import 'product.dart';

class Comparison extends Equatable {
  final List<Product> products;

  const Comparison({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];
}
