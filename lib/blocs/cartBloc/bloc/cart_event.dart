part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddProductEvent extends CartEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductEvent extends CartEvent {
  final Product product;

  const RemoveProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class ClearCartEvent extends CartEvent {}
