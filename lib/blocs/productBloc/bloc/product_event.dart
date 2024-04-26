part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends ProductEvent {}

class UpdateProductsEvent extends ProductEvent {
  final List<Product> products;

  const UpdateProductsEvent(this.products);

  List<Object> get props => [products];
}

class GetProductEvent extends ProductEvent {
  final List<String> productIds;

  const GetProductEvent({required this.productIds});
}
