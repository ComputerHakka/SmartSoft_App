part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final Cart cart;

  const CartLoadedState({this.cart = const Cart()});

  @override
  List<Object> get props => [cart];
}

class CartErrorState extends CartState {
  @override
  List<Object> get props => [];
}
